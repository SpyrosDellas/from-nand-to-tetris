@START 
0;JMP 

(EQ) 
@R13 
M=D 
@SP 
AM=M-1 
D=M 
A=A-1 
D=D-M 
M=0 
@END_EQ 
D;JNE 
@SP 
A=M-1 
M=-1 
(END_EQ) 
@R13 
A=M 
0;JMP 

(GT) 
@R13 
M=D 
@SP 
AM=M-1 
D=M 
A=A-1 
D=M-D 
M=0 
@END_GT 
D;JLE 
@SP 
A=M-1 
M=-1 
(END_GT) 
@R13 
A=M 
0;JMP 

(LT) 
@R13 
M=D 
@SP 
AM=M-1 
D=M 
A=A-1 
D=M-D 
M=0 
@END_LT 
D;JGE 
@SP 
A=M-1 
M=-1 
(END_LT) 
@R13 
A=M 
0;JMP 

(START) 
// push constant 3030 
@3030 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// pop pointer 0 
@SP 
AM=M-1 
D=M 
@R3 
M=D 

// push constant 3040 
@3040 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// pop pointer 1 
@SP 
AM=M-1 
D=M 
@R4 
M=D 

// push constant 32 
@32 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// pop this 2 
@THIS 
D=M 
@2 
D=D+A 
@R13 
M=D 
@SP 
AM=M-1 
D=M 
@R13 
A=M 
M=D 

// push constant 46 
@46 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// pop that 6 
@THAT 
D=M 
@6 
D=D+A 
@R13 
M=D 
@SP 
AM=M-1 
D=M 
@R13 
A=M 
M=D 

// push pointer 0 
@R3 
D=M 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// push pointer 1 
@R4 
D=M 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// add 
@SP 
AM=M-1 
D=M 
A=A-1 
M=D+M 

// push this 2 
@THIS 
D=M 
@2 
A=D+A 
D=M 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// sub 
@SP 
AM=M-1 
D=M 
A=A-1 
M=M-D 

// push that 6 
@THAT 
D=M 
@6 
A=D+A 
D=M 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// add 
@SP 
AM=M-1 
D=M 
A=A-1 
M=D+M 

