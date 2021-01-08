#!/usr/bin/env python
# coding: utf-8

# In[26]:


import os, sys


# In[27]:


class Parser(object):
    """ Parser: Handles the parsing of a single .vm file, and encapsulates
    access to the input code. It reads VM commands, parses them, and provides
    convenient access to their components. In addition, it removes all white space
    and comments.
    """


    def __init__(self, filename):

        # Read the xxx.asm file into a list of strings, one for each line
        with open(filename) as f:
            raw_lines = f.readlines()

        # Strip all comments and white space and split the command
        self.lines = []
        for line in raw_lines:
            line = line.strip()
            if not (line.startswith('//') or line == ''):
                # Remove any end of line comments
                line = line.split('//')[0]
                # Split the command into a list of strings
                self.lines.append(line.split())
            else:
                continue

        self.index = 0
        self.command = ''

        return


    def hasMoreCommands(self):
        """ Are there more commands in the input? """

        return self.index <= (len(self.lines) - 1)


    def advance(self):
        """ Reads the next command from the input and makes it the current
        command. Should be called only if hasMoreCommands() is true.
        Initially there is no current command.
        """

        self.command = self.lines[self.index]
        self.index += 1

        return


    def commandType(self):
        """ Returns the type of the current VM command. C_ARITHMETIC is returned
          for all the arithmetic commands.
        """

        command_type = {'add': 'C_ARITHMETIC', 'sub': 'C_ARITHMETIC',
                        'neg': 'C_ARITHMETIC', 'eq': 'C_ARITHMETIC',
                        'gt': 'C_ARITHMETIC', 'lt': 'C_ARITHMETIC',
                        'and': 'C_ARITHMETIC', 'or': 'C_ARITHMETIC',
                        'not': 'C_ARITHMETIC',
                        'push': 'C_PUSH',
                        'pop': 'C_POP',
                        'label': 'C_LABEL',
                        'goto': 'C_GOTO',
                        'if-goto': 'C_IF',
                        'function': 'C_FUNCTION',
                        'return': 'C_RETURN',
                        'call': 'C_CALL'}

        assert self.command[0] in command_type, "Syntax Error: Command '{0}' is invalid".format(self.command[0])

        return command_type[self.command[0]]



# In[31]:


class CodeWriter(object):
    """CodeWriter: Translates VM commands into Hack assembly code

      NOTE: A single instance of CodeWriter is utilised to handle the whole assembly
      code generation process, even when translating multiple vm files
      """


    def __init__(self, out_filename, bootstrap):

        self.out_filename = out_filename

        # Current VM file under translation, required for the static segment
        self.fileName = None

        # Current function name under translation, required for creating return labels when
        #other functions
        self.functionName = None

        # Output code
        self.code = []

        # Label counters for eq, gt, lt and call commands
        self.eq_counter = 0
        self.gt_counter = 0
        self.lt_counter = 0
        self.call_counter = 0


        if bootstrap:
            # Write bootstrap code as per the VM language specification
            self.code.append('// BOOTSTRAP CODE - SYS.INIT \n')
            # SP=256
            self.code.append('@256 \n')
            self.code.append('D=A \n')
            self.code.append('@SP \n')
            self.code.append('M=D \n')
            # Call Sys.init (has no arguments)
            self.functionName = 'SYS.'
            self.writeCall(['call', 'SYS.INIT', '0'])
        else:
            # Jump to the program start.
            # This avoids execution of the template code for eq, lt and gt
            self.code.append('// BOOTSTRAP CODE - BYPASSES EQ, GT, LT TEMPLATE CODE BLOCK \n')
            self.code.append('@START \n')
            self.code.append('0;JMP \n')
            self.code.append('\n')


        """ We note that:
        - All three comparison commands eq, gt and lt require 11 assembly
        instructions each (involving decision branching with a unique label (XXX...)
        - Comparisons are encountered multiple times in any non trivial program

        Based on above observations, we can achieve a more compact ASM file if we
        create a template code for the three comparisons at the beginning of the ASM
        file.
        This way every time a comparison is executed in the main program, execution
        branches to and from the corresponding template instead.
        Branching to/from the comparison template requires only 4 assembly
        instructions.
        Note: The above does not result in any performance improvement."""

        # Equality template code: true if x=y, else false
        self.code.append('(EQ) \n')
        # Save return address to R13
        self.code.append('@R13 \n')
        self.code.append('M=D \n')
        # SP-- and eq
        self.code.append('@SP \n')
        self.code.append('AM=M-1 \n')
        self.code.append('D=M \n')
        self.code.append('A=A-1 \n')
        self.code.append('D=D-M \n')
        self.code.append('M=0 \n')  # Set to false first
        self.code.append('@END_EQ \n')
        self.code.append('D;JNE \n') # If not equal we are done
        self.code.append('@SP \n')
        self.code.append('A=M-1 \n')
        self.code.append('M=-1 \n')
        self.code.append('(END_EQ) \n')
        # Return
        self.code.append('@R13 \n')
        self.code.append('A=M \n')
        self.code.append('0;JMP \n')
        # Add a new line for clarity
        self.code.append('\n')

        # Greater than template code: true if x>y, else false
        self.code.append('(GT) \n')
        # Save return address to R13
        self.code.append('@R13 \n')
        self.code.append('M=D \n')
        # SP-- and gt
        self.code.append('@SP \n')
        self.code.append('AM=M-1 \n')
        self.code.append('D=M \n')
        self.code.append('A=A-1 \n')
        self.code.append('D=M-D \n')
        self.code.append('M=0 \n')  # Set to false first
        self.code.append('@END_GT \n')
        self.code.append('D;JLE \n') # If less or equal we are done
        self.code.append('@SP \n')
        self.code.append('A=M-1 \n')
        self.code.append('M=-1 \n')
        self.code.append('(END_GT) \n')
        # Return
        self.code.append('@R13 \n')
        self.code.append('A=M \n')
        self.code.append('0;JMP \n')
        # Add a new line for clarity
        self.code.append('\n')

        # Less than template code: true if x<y, else false
        self.code.append('(LT) \n')
        # Save return address to R13
        self.code.append('@R13 \n')
        self.code.append('M=D \n')
        # SP-- and lt
        self.code.append('@SP \n')
        self.code.append('AM=M-1 \n')
        self.code.append('D=M \n')
        self.code.append('A=A-1 \n')
        self.code.append('D=M-D \n')
        self.code.append('M=0 \n')  # Set to false first
        self.code.append('@END_LT \n')
        self.code.append('D;JGE \n') # If greater or equal we are done
        self.code.append('@SP \n')
        self.code.append('A=M-1 \n')
        self.code.append('M=-1 \n')
        self.code.append('(END_LT) \n')
        # Return
        self.code.append('@R13 \n')
        self.code.append('A=M \n')
        self.code.append('0;JMP \n')
        # Add a new line for clarity
        self.code.append('\n')

        # Create program START label, if there is no Sys.init
        if not bootstrap:
            self.code.append('(START) \n')

        return


    def setFileName(self, filename):
        """Informs the CodeWriter that the translation of a new VM file has started.
        """
        self.fileName = filename

        return


    def saveToFile(self):
        with open(self.out_filename, mode='w') as f:
            f.writelines(self.code)

        return


    def writeArithmetic(self, command):
        """ Writes the assembly code that is the translation of the given arithmetic
        command.

        Note:
        The VM implementation represents true as -1 (minus one) and
        false as 0 (zero).
        """
        command = command[0]

        if command == 'add':
            """ Integer addition x+y, where y is the stack's top value"""
            self.code.append('// add \n')
            # SP-- and sub
            self.code.append('@SP \n')
            self.code.append('AM=M-1 \n')
            self.code.append('D=M \n')
            self.code.append('A=A-1 \n')
            self.code.append('M=D+M \n')
            # Add a new line for clarity
            self.code.append('\n')

        elif command == 'sub':
            """ Integer subtraction x-y, where y is the stack's top value"""
            self.code.append('// sub \n')
            # SP-- and sub
            self.code.append('@SP \n')
            self.code.append('AM=M-1 \n')
            self.code.append('D=M \n')
            self.code.append('A=A-1 \n')
            self.code.append('M=M-D \n')
            # Add a new line for clarity
            self.code.append('\n')

        elif command == 'neg':
            """ Arithmetic negation -y, where y is the stack's top value"""
            self.code.append('// neg \n')
            self.code.append('@SP \n')
            self.code.append('A=M-1 \n')
            self.code.append('M=-M \n')
            # Add a new line for clarity
            self.code.append('\n')

        elif command == 'eq':
            """Equality, true if x=y, else false"""
            self.eq_counter += 1
            self.code.append('// eq \n')
            # Point to return label and save it's address to D register
            self.code.append('@EQ{0} \n'.format(self.eq_counter))
            self.code.append('D=A \n')
            # Goto template code for eq
            self.code.append('@EQ \n')
            self.code.append('0;JMP \n')
            # Return label
            self.code.append('(EQ{0}) \n'.format(self.eq_counter))
            # Add a new line for clarity
            self.code.append('\n')

        elif command == 'gt':
            """Greater than, true if x>y, else false. y is the stack's top value"""
            self.gt_counter += 1
            self.code.append('// gt \n')
            # Point to return label and save it's address to D register
            self.code.append('@GT{0} \n'.format(self.gt_counter))
            self.code.append('D=A \n')
            # Goto template code for gt
            self.code.append('@GT \n')
            self.code.append('0;JMP \n')
            # Return label
            self.code.append('(GT{0}) \n'.format(self.gt_counter))
            # Add a new line for clarity
            self.code.append('\n')

        elif command == 'lt':
            """Less than, true if x<y, else false. y is the stack's top value"""
            self.lt_counter += 1
            self.code.append('// lt \n')
            # Point to return label and save it's address to D register
            self.code.append('@LT{0} \n'.format(self.lt_counter))
            self.code.append('D=A \n')
            # Goto template code for lt
            self.code.append('@LT \n')
            self.code.append('0;JMP \n')
            # Return label
            self.code.append('(LT{0}) \n'.format(self.lt_counter))
            # Add a new line for clarity
            self.code.append('\n')

        elif command == 'and':
            """Bitwise and """
            self.code.append('// and \n')
            # SP-- and bitwise 'and'
            self.code.append('@SP \n')
            self.code.append('AM=M-1 \n')
            self.code.append('D=M \n')
            self.code.append('A=A-1 \n')
            self.code.append('M=D&M \n')
            # Add a new line for clarity
            self.code.append('\n')

        elif command == 'or':
            """Bitwise or """
            self.code.append('// or \n')
            # SP-- and bitwise 'or'
            self.code.append('@SP \n')
            self.code.append('AM=M-1 \n')
            self.code.append('D=M \n')
            self.code.append('A=A-1 \n')
            self.code.append('M=D|M \n')
            # Add a new line for clarity
            self.code.append('\n')

        elif command == 'not':
            """Bitwise not """
            self.code.append('// not \n')
            self.code.append('@SP \n')
            self.code.append('A=M-1 \n')
            self.code.append('M=!M \n')
            # Add a new line for clarity
            self.code.append('\n')

        return


    def writePushPop(self, command):
        """ Writes the assembly code that is the translation of the given command,
        where command is either 'push' or 'pop'.

        - push <segment> <index>: Push the value of segment[index] onto the stack.

        - pop <segment> <index>: Pop the top stack value and store it
          in segment[index].
        """

        command, segment, index = command

        if command == 'push':

            if segment == 'constant':
                """ This segment is virtual, as it does not occupy any physical space
                on the target architecture. Instead, the VM implementation handles
                any VM access to <constant i> by simply supplying the constant i.
                """
                self.code.append('// push constant {0} \n'.format(index))
                # D=index
                self.code.append('@{0} \n'.format(index))
                self.code.append('D=A \n')
                # *SP=D
                self.code.append('@SP \n')
                self.code.append('A=M \n')
                self.code.append('M=D \n')
                # SP++
                self.code.append('@SP \n')
                self.code.append('M=M+1 \n')
                # Add a new line for clarity
                self.code.append('\n')

            elif segment == 'local':
                """ Stores the function’s local variables.
                Allocated dynamically by the VM implementation and initialized to 0’s
                when the function is entered.
                """
                self.code.append('// push local {0} \n'.format(index))
                # D=*(*LCL+index)
                self.code.append('@LCL \n')
                self.code.append('D=M \n')
                self.code.append('@{0} \n'.format(index))
                self.code.append('A=D+A \n')
                self.code.append('D=M \n')
                # *SP=D
                self.code.append('@SP \n')
                self.code.append('A=M \n')
                self.code.append('M=D \n')
                # SP++
                self.code.append('@SP \n')
                self.code.append('M=M+1 \n')
                # Add a new line for clarity
                self.code.append('\n')

            elif segment == 'argument':
                """ Stores the function’s arguments.
                Allocated dynamically by the VM implementation when the function
                is entered.
                """
                self.code.append('// push argument {0} \n'.format(index))
                # D=*(*ARG+index)
                self.code.append('@ARG \n')
                self.code.append('D=M \n')
                self.code.append('@{0} \n'.format(index))
                self.code.append('A=D+A \n')
                self.code.append('D=M \n')
                # *SP=D
                self.code.append('@SP \n')
                self.code.append('A=M \n')
                self.code.append('M=D \n')
                # SP++
                self.code.append('@SP \n')
                self.code.append('M=M+1 \n')
                # Add a new line for clarity
                self.code.append('\n')

            elif segment == 'this':
                """ General-purpose segment.
                Any VM function can use this segment to manipulate selected
                areas on the heap.
                """
                self.code.append('// push this {0} \n'.format(index))
                # D=*(*THIS+index)
                self.code.append('@THIS \n')
                self.code.append('D=M \n')
                self.code.append('@{0} \n'.format(index))
                self.code.append('A=D+A \n')
                self.code.append('D=M \n')
                # *SP=D
                self.code.append('@SP \n')
                self.code.append('A=M \n')
                self.code.append('M=D \n')
                # SP++
                self.code.append('@SP \n')
                self.code.append('M=M+1 \n')
                # Add a new line for clarity
                self.code.append('\n')

            elif segment == 'that':
                """ General-purpose segment.
                Any VM function can use this segment to manipulate selected
                areas on the heap.
                """
                self.code.append('// push that {0} \n'.format(index))
                # D=*(*THAT+index)
                self.code.append('@THAT \n')
                self.code.append('D=M \n')
                self.code.append('@{0} \n'.format(index))
                self.code.append('A=D+A \n')
                self.code.append('D=M \n')
                # *SP=D
                self.code.append('@SP \n')
                self.code.append('A=M \n')
                self.code.append('M=D \n')
                # SP++
                self.code.append('@SP \n')
                self.code.append('M=M+1 \n')
                # Add a new line for clarity
                self.code.append('\n')

            elif segment == 'temp':
                """The temp segment is mapped on locations 5–12 (also called R5.. R12).
                Thus access to 'temp i' is translated to assembly code that accesses
                RAM location 5+i.
                """
                self.code.append('// push temp {0} \n'.format(index))
                # D=*(5+index)
                self.code.append('@R{} \n'.format(5+int(index)))
                self.code.append('D=M \n')
                # *SP=D
                self.code.append('@SP \n')
                self.code.append('A=M \n')
                self.code.append('M=D \n')
                # SP++
                self.code.append('@SP \n')
                self.code.append('M=M+1 \n')
                # Add a new line for clarity
                self.code.append('\n')

            elif segment == 'pointer':
                """The pointer segment is mapped on RAM locations 3–4 (also called THIS
                and THAT). Thus access to pointer i is translated to assembly
                code that accesses RAM location 3+i
                """
                self.code.append('// push pointer {0} \n'.format(index))
                # D=*(3+index)
                self.code.append('@R{} \n'.format(3+int(index)))
                self.code.append('D=M \n')
                # *SP=D
                self.code.append('@SP \n')
                self.code.append('A=M \n')
                self.code.append('M=D \n')
                # SP++
                self.code.append('@SP \n')
                self.code.append('M=M+1 \n')
                # Add a new line for clarity
                self.code.append('\n')

            elif segment == 'static':
                """ According to the Hack machine language specification, when a new
                symbol is encountered for the first time in an assembly program, the
                assembler allocates a new RAM address to it, starting at address 16.
                This convention can be exploited to represent each static variable
                number j in a VM file f as the assembly language symbol f.j.
                For example, suppose that the file Xxx.vm contains the command
                'push static 3'. This command can be translated to the Hack assembly
                commands @Xxx.3 and D=M, followed by additional assembly code that
                pushes D’s value to the stack.
                """
                self.code.append('// push static {0} \n'.format(index))
                # @fileName.index
                self.code.append('@{0}.{1} \n'.format(self.fileName, index))
                self.code.append('D=M \n')
                # *SP=D
                self.code.append('@SP \n')
                self.code.append('A=M \n')
                self.code.append('M=D \n')
                # SP++
                self.code.append('@SP \n')
                self.code.append('M=M+1 \n')
                # Add a new line for clarity
                self.code.append('\n')


        elif command == 'pop':

            assert segment != 'constant', 'Illegal command: pop constant ...'

            if segment == 'local':
                """ Stores the function’s local variables.
                Allocated dynamically by the VM implementation and initialized to 0’s
                when the function is entered.
                """
                self.code.append('// pop local {0} \n'.format(index))
                # R13=*LCL+index
                self.code.append('@LCL \n')
                self.code.append('D=M \n')
                self.code.append('@{0} \n'.format(index))
                self.code.append('D=D+A \n')
                self.code.append('@R13 \n')
                self.code.append('M=D \n')
                # SP-- and D=*SP--
                self.code.append('@SP \n')
                self.code.append('AM=M-1 \n')
                self.code.append('D=M \n')
                #*R13=D
                self.code.append('@R13 \n')
                self.code.append('A=M \n')
                self.code.append('M=D \n')
                # Add a new line for clarity
                self.code.append('\n')

            elif segment == 'argument':
                """ Stores the function’s arguments.
                Allocated dynamically by the VM implementation when the function
                is entered.
                """
                self.code.append('// pop argument {0} \n'.format(index))
                # R13=*ARG+index
                self.code.append('@ARG \n')
                self.code.append('D=M \n')
                self.code.append('@{0} \n'.format(index))
                self.code.append('D=D+A \n')
                self.code.append('@R13 \n')
                self.code.append('M=D \n')
                # SP-- and D=*SP--
                self.code.append('@SP \n')
                self.code.append('AM=M-1 \n')
                self.code.append('D=M \n')
                #*R13=D
                self.code.append('@R13 \n')
                self.code.append('A=M \n')
                self.code.append('M=D \n')
                # Add a new line for clarity
                self.code.append('\n')

            elif segment == 'this':
                """ General-purpose segment.
                Any VM function can use this segment to manipulate selected
                areas on the heap.
                """
                self.code.append('// pop this {0} \n'.format(index))
                # R13=*THIS+index
                self.code.append('@THIS \n')
                self.code.append('D=M \n')
                self.code.append('@{0} \n'.format(index))
                self.code.append('D=D+A \n')
                self.code.append('@R13 \n')
                self.code.append('M=D \n')
                # SP-- and D=*SP--
                self.code.append('@SP \n')
                self.code.append('AM=M-1 \n')
                self.code.append('D=M \n')
                #*R13=D
                self.code.append('@R13 \n')
                self.code.append('A=M \n')
                self.code.append('M=D \n')
                # Add a new line for clarity
                self.code.append('\n')

            elif segment == 'that':
                """ General-purpose segment.
                Any VM function can use this segment to manipulate selected
                areas on the heap.
                """
                self.code.append('// pop that {0} \n'.format(index))
                # R13=*THAT+index
                self.code.append('@THAT \n')
                self.code.append('D=M \n')
                self.code.append('@{0} \n'.format(index))
                self.code.append('D=D+A \n')
                self.code.append('@R13 \n')
                self.code.append('M=D \n')
                # SP-- and D=*SP--
                self.code.append('@SP \n')
                self.code.append('AM=M-1 \n')
                self.code.append('D=M \n')
                #*R13=D
                self.code.append('@R13 \n')
                self.code.append('A=M \n')
                self.code.append('M=D \n')
                # Add a new line for clarity
                self.code.append('\n')

            elif segment == 'temp':
                """The temp segment is mapped on locations 5–12 (also called R5.. R12).
                Thus access to 'temp i' is translated to assembly code that accesses
                RAM location 5+i.
                """
                self.code.append('// pop temp {0} \n'.format(index))
                # SP-- and D=*SP--
                self.code.append('@SP \n')
                self.code.append('AM=M-1 \n')
                self.code.append('D=M \n')
                # *(5+index)=D
                self.code.append('@R{} \n'.format(5+int(index)))
                self.code.append('M=D \n')
                # Add a new line for clarity
                self.code.append('\n')

            elif segment == 'pointer':
                """The pointer segment is mapped on RAM locations 3–4 (also called THIS
                and THAT). Thus access to pointer i is translated to assembly
                code that accesses RAM location 3+i
                """
                self.code.append('// pop pointer {0} \n'.format(index))
                # SP-- and D=*SP--
                self.code.append('@SP \n')
                self.code.append('AM=M-1 \n')
                self.code.append('D=M \n')
                # *(3+index)=D
                self.code.append('@R{} \n'.format(3+int(index)))
                self.code.append('M=D \n')
                # Add a new line for clarity
                self.code.append('\n')

            elif segment == 'static':
                """ According to the Hack machine language specification, when a new
                symbol is encountered for the first time in an assembly program, the
                assembler allocates a new RAM address to it, starting at address 16.
                This convention can be exploited to represent each static variable
                number j in a VM file f as the assembly language symbol f.j.
                For example, suppose that the file Xxx.vm contains the command
                'push static 3'. This command can be translated to the Hack assembly
                commands @Xxx.3 and D=M, followed by additional assembly code that
                pushes D’s value to the stack.
                """
                self.code.append('// pop static {0} \n'.format(index))
                # SP-- and D=*SP--
                self.code.append('@SP \n')
                self.code.append('AM=M-1 \n')
                self.code.append('D=M \n')
                # @fileName.index
                self.code.append('@{0}.{1} \n'.format(self.fileName, index))
                self.code.append('M=D \n')
                # Add a new line for clarity
                self.code.append('\n')
        return


    def writeLabel(self, command):
        """ Writes the assembly code that effects the label command.

        - Each 'label b' command in a VM function 'f' generates a globally unique
        symbol 'f$b' where 'f' is the function name and 'b' is the label symbol within
        the VM function’s code.

        - When translating <goto b> and <if-goto b> VM commands into Hack assembly,
        the full label specification 'f$b' must be used instead of 'b'.

        - When a label is encountered at the beginning of the file, before any function definition,
        that label is made unique as follows: <filename>.$b

        NOTE: It is implied that no jumping is allowed between functions, as this would mix up the
        function execution frames in the stack.
        """

        label = command[1]

        self.code.append('// label {0} \n'.format(label))

        # The Hack assembly language specification stipulates labels to be in CAPITAL letters
        label = label.upper()
        if self.functionName is None:
            label = '.'.join([self.fileName.upper(), '$']) + label  # Use <filename>.$<label> as label
        else:
            label = '$'.join([self.functionName.upper(), label])

        self.code.append('({0}) \n'.format(label))
        # Add a new line for clarity
        self.code.append('\n')

        return


    def writeGoto(self, command):
        """ Writes the assembly code that effects the goto command.

        See also the writeLabel documentation above.
        """

        label = command[1]

        self.code.append('// goto {0} \n'.format(label))

        # The Hack assembly language specification stipulates labels to be in CAPITAL letters
        label = label.upper()
        if self.functionName is None:
            label = '.'.join([self.fileName.upper(), '$']) + label  # Use <filename>.$<label> as label
        else:
            label = '$'.join([self.functionName.upper(), label])

        self.code.append('@{0} \n'.format(label))
        self.code.append('0;JMP \n')
        # Add a new line for clarity
        self.code.append('\n')

        return


    def writeIf(self, command):
        """ Writes the assembly code that effects the if-goto command.

        See also the writeLabel documentation above.
        """

        label = command[1]

        self.code.append('// if-goto {0} \n'.format(label))

        # The Hack assembly language specification stipulates labels to be in CAPITAL letters
        label = label.upper()
        if self.functionName is None:
            label = '.'.join([self.fileName.upper(), '$']) + label  # Use <filename>.$<label> as label
        else:
            label = '$'.join([self.functionName.upper(), label])

        # SP-- and D=*SP--
        self.code.append('@SP \n')
        self.code.append('AM=M-1 \n')
        self.code.append('D=M \n')
        self.code.append('@{0} \n'.format(label))
        self.code.append('D; JNE \n')
        # Add a new line for clarity
        self.code.append('\n')

        return


    def writeCall(self, command):
        """ Writes assembly code that effects the <call fname nargs> command.

        GENERATED PSEUDO CODE:
        push return-address      // (Using the label declared below)
        push LCL                 // Save LCL of the calling function
        push ARG                 // Save ARG of the calling function
        push THIS                // Save THIS of the calling function
        push THAT                // Save THAT of the calling function
        ARG = SP-n-5             // Reposition ARG (n = number of args)
        LCL = SP                 // Reposition LCL
        goto f                   // Transfer control
        (return-address)         // Declare a label for the return-address
        """

        command, fname, nargs = command

        self.code.append('// call {0} {1} \n'.format(fname, nargs))

        # Create a new return label
        self.call_counter += 1
        ret_label = '$'.join([self.functionName.upper(), 'RET.']) + str(self.call_counter)

        # push return-address
        self.code.append('@{0} \n'.format(ret_label))
        self.code.append('D=A \n')
        self.code.append('@SP \n')
        self.code.append('A=M \n')
        self.code.append('M=D \n')
        self.code.append('@SP \n')
        self.code.append('M=M+1 \n')

        # push LCL
        self.code.append('@LCL \n')
        self.code.append('D=M \n')
        self.code.append('@SP \n')
        self.code.append('A=M \n')
        self.code.append('M=D \n')
        self.code.append('@SP \n')
        self.code.append('M=M+1 \n')

        # push ARG
        self.code.append('@ARG \n')
        self.code.append('D=M \n')
        self.code.append('@SP \n')
        self.code.append('A=M \n')
        self.code.append('M=D \n')
        self.code.append('@SP \n')
        self.code.append('M=M+1 \n')

        # push THIS
        self.code.append('@THIS \n')
        self.code.append('D=M \n')
        self.code.append('@SP \n')
        self.code.append('A=M \n')
        self.code.append('M=D \n')
        self.code.append('@SP \n')
        self.code.append('M=M+1 \n')

        # push THAT
        self.code.append('@THAT \n')
        self.code.append('D=M \n')
        self.code.append('@SP \n')
        self.code.append('A=M \n')
        self.code.append('M=D \n')
        self.code.append('@SP \n')
        self.code.append('M=M+1 \n')

        # ARG = *SP - (nargs + 5)
        self.code.append('@SP \n')
        self.code.append('D=M \n')
        self.code.append('@{0} \n'.format(str(int(nargs) + 5)))
        self.code.append('D=D-A \n')
        self.code.append('@ARG \n')
        self.code.append('M=D \n')

        # LCL = *SP
        self.code.append('@SP \n')
        self.code.append('D=M \n')
        self.code.append('@LCL \n')
        self.code.append('M=D \n')

        # Goto fname
        self.code.append('@{0} \n'.format(fname.upper()))
        self.code.append('0;JMP \n')

        # Return label
        self.code.append('({0}) \n'.format(ret_label))

        # Add a new line for clarity
        self.code.append('\n')

        return


    def writeReturn(self, command):
        """ Writes assembly code that effects the <return> command.

        GENERATED PSEUDO CODE:
        FRAME = *LCL             // FRAME is a temporary variable
        RET = *(FRAME-5)         // Put the return-address in a temp. var.
        *ARG = pop()             // Reposition the return value for the caller
        SP = *ARG+1               // Restore SP of the caller
        THAT = *(FRAME-1)        // Restore THAT of the caller
        THIS = *(FRAME-2)        // Restore THIS of the caller
        ARG = *(FRAME-3)         // Restore ARG of the caller
        LCL = *(FRAME-4)         // Restore LCL of the caller
        goto RET                 // Goto return-address (in the caller’s code)
        """

        self.code.append('// return \n')

        # Frame = *LCL
        self.code.append('@LCL \n')
        self.code.append('D=M \n')
        self.code.append('@Frame \n')
        self.code.append('M=D \n')

        # Ret = *(FRAME-5) - Store temporarily the return address to avoid overwriting
        # by *ARG = pop() if the function has zero arguments
        self.code.append('@5 \n')
        self.code.append('A=D-A \n')
        self.code.append('D=M \n')
        self.code.append('@Ret \n')
        self.code.append('M=D \n')

        # *ARG = pop() - Returns the value at the top of the stack to the position of ARG 0
        self.code.append('@SP \n')
        self.code.append('AM=M-1 \n')
        self.code.append('D=M \n')
        self.code.append('@ARG \n')
        self.code.append('A=M \n')
        self.code.append('M=D \n')

        # SP = *ARG+1 - Restores caller function's SP pointer
        self.code.append('@ARG \n')
        self.code.append('D=M \n')
        self.code.append('@SP \n')
        self.code.append('M=D+1 \n')

        # THAT = *(FRAME-1)
        self.code.append('@Frame \n')
        self.code.append('A=M-1 \n')
        self.code.append('D=M \n')
        self.code.append('@THAT \n')
        self.code.append('M=D \n')

        # THIS = *(FRAME-2)
        self.code.append('@Frame \n')
        self.code.append('D=M \n')
        self.code.append('@2 \n')
        self.code.append('A=D-A \n')
        self.code.append('D=M \n')
        self.code.append('@THIS \n')
        self.code.append('M=D \n')

        # ARG = *(FRAME-3)
        self.code.append('@Frame \n')
        self.code.append('D=M \n')
        self.code.append('@3 \n')
        self.code.append('A=D-A \n')
        self.code.append('D=M \n')
        self.code.append('@ARG \n')
        self.code.append('M=D \n')

        # LCL = *(FRAME-4)
        self.code.append('@Frame \n')
        self.code.append('D=M \n')
        self.code.append('@4 \n')
        self.code.append('A=D-A \n')
        self.code.append('D=M \n')
        self.code.append('@LCL \n')
        self.code.append('M=D \n')

        # goto Ret
        self.code.append('@Ret \n')
        self.code.append('A=M \n')
        self.code.append('0;JMP \n')

        # Add a new line for clarity
        self.code.append('\n')

        return


    def writeFunction(self, command):
        """ Writes assembly code that effects the <function fname numlocals> command.

        - Declares the label for the function

        - Pushes n = numlocals local variables to the stack and initializes
          their values to 0
        """

        command, fname, numlocals = command

        # First update functionName attribute to reflect the name of the
        # function under translation
        self.functionName = fname

        # Reset call counter
        self.call_counter = 0

        self.code.append('// function {0} {1} \n'.format(fname, numlocals))
        self.code.append('({0}) \n'.format(fname.upper()))

        for _ in range(int(numlocals)):
            # *SP=0
            self.code.append('@SP \n')
            self.code.append('A=M \n')
            self.code.append('M=0 \n')
            # SP++
            self.code.append('@SP \n')
            self.code.append('M=M+1 \n')

        # Add a new line for clarity
        self.code.append('\n')

        return



# In[32]:


class Translate(object):


    def __init__(self, source):

        """ Source can be either a file name of the form Xxx.vm (the extension is mandatory)
        or a directory name containing one or more .vm files (in which case there is no extension).

        The result of the translation is always a single assembly language file named
        Xxx.asm, created in the same directory as the input Xxx.
        """

        self.parsers = []
        self.modules = []

        # source is a single .vm file
        if os.path.isfile(source) and source.endswith('.vm'):
            self.parsers.append(Parser(source))
            # Extract the xxx.vm filename from source, in case source is a path,
            # for example C:\NAND 2 Tetris\pong.vm
            _ = os.path.basename(source)
            # Remove .vm extension and append to modules list
            self.modules.append(_.split('.')[0])
            # Instantiate CodeWriter with no bootstrap code
            output_file = source.split('.')[0] + '.asm'
            self.code_writer = CodeWriter(output_file, bootstrap=False)

        # source is a directory
        elif os.path.isdir(source):
            # Normalise the source path to avoid errors in case path ends with \\, etc.
            source = os.path.normpath(source)
            # Create one Parser instance per input VM file, filename is a directory
            with os.scandir(source) as d:
                for entry in d:
                    if entry.is_file() and entry.name.endswith('.vm'):
                        # Create one Parser instance per .vm file in the directory
                        self.parsers.append(Parser(entry.path))
                        self.modules.append(entry.name.split('.')[0])
            # Instantiate CodeWriter with the output filename set
            # to <directory name>.asm and bootstrap code that calls 'Sys.init' as per
            # the VM language specification
            output_file = os.path.join(source, os.path.basename(source) + '.asm')
            self.code_writer = CodeWriter(output_file, bootstrap=True)

        return


    def translate(self):
        """
        """

        for parser, module in zip(self.parsers, self.modules):
            # Set CodeWriter's fileName attribute to the name of currently
            # processed module
            self.code_writer.setFileName(module)

            while parser.hasMoreCommands():
                parser.advance()

                if parser.commandType() == 'C_ARITHMETIC':
                    self.code_writer.writeArithmetic(parser.command)

                elif parser.commandType() in ['C_PUSH', 'C_POP']:
                    self.code_writer.writePushPop(parser.command)

                elif parser.commandType() == 'C_LABEL':
                    self.code_writer.writeLabel(parser.command)

                elif parser.commandType() == 'C_GOTO':
                    self.code_writer.writeGoto(parser.command)

                elif parser.commandType() == 'C_IF':
                    self.code_writer.writeIf(parser.command)

                elif parser.commandType() == 'C_FUNCTION':
                    self.code_writer.writeFunction(parser.command)

                elif parser.commandType() == 'C_RETURN':
                    self.code_writer.writeReturn(parser.command)

                elif parser.commandType() == 'C_CALL':
                    self.code_writer.writeCall(parser.command)

        return


    def save(self):
        self.code_writer.saveToFile()

        return



source = sys.argv[1]

translate = Translate(source)
translate.translate()
translate.save()
