// BOOTSTRAP CODE - SYS.INIT
//@256
//D=A
//@SP
//M=D 
@SYS.INIT
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

// function Sys.init 0
(SYS.INIT)

// push constant 4000
@4000
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

// push constant 5000
@5000
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

// call Sys.main 0
@SYS.INIT$RET.1
D=A
@SP
A=M
M=D
@SP
M=M+1
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1
@THIS
D=M
@SP
A=M
M=D
@SP
M=M+1
@THAT
D=M
@SP
A=M
M=D
@SP
M=M+1
@SP
D=M
@5
D=D-A
@ARG
M=D
@SP
D=M
@LCL
M=D
@SYS.MAIN
0;JMP
(SYS.INIT$RET.1)

// pop temp 1
@SP
AM=M-1
D=M
@R6
M=D

// label LOOP
(SYS.INIT$LOOP)

// goto LOOP
@SYS.INIT$LOOP
0;JMP

// function Sys.main 5
(SYS.MAIN)
@SP
A=M
M=0
@SP
M=M+1
@SP
A=M
M=0
@SP
M=M+1
@SP
A=M
M=0
@SP
M=M+1
@SP
A=M
M=0
@SP
M=M+1
@SP
A=M
M=0
@SP
M=M+1

// push constant 4001
@4001
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

// push constant 5001
@5001
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

// push constant 200
@200
D=A
@SP
A=M
M=D
@SP
M=M+1

// pop local 1
@LCL
D=M
@1
D=D+A
@R13
M=D
@SP
AM=M-1
D=M
@R13
A=M
M=D

// push constant 40
@40
D=A
@SP
A=M
M=D
@SP
M=M+1

// pop local 2
@LCL
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

// push constant 6
@6
D=A
@SP
A=M
M=D
@SP
M=M+1

// pop local 3
@LCL
D=M
@3
D=D+A
@R13
M=D
@SP
AM=M-1
D=M
@R13
A=M
M=D

// push constant 123
@123
D=A
@SP
A=M
M=D
@SP
M=M+1

// call Sys.add12 1
@SYS.MAIN$RET.1
D=A
@SP
A=M
M=D
@SP
M=M+1
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1
@THIS
D=M
@SP
A=M
M=D
@SP
M=M+1
@THAT
D=M
@SP
A=M
M=D
@SP
M=M+1
@SP
D=M
@6
D=D-A
@ARG
M=D
@SP
D=M
@LCL
M=D
@SYS.ADD12
0;JMP
(SYS.MAIN$RET.1)

// pop temp 0
@SP
AM=M-1
D=M
@R5
M=D

// push local 0
@LCL
D=M
@0
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1

// push local 1
@LCL
D=M
@1
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1

// push local 2
@LCL
D=M
@2
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1

// push local 3
@LCL
D=M
@3
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1

// push local 4
@LCL
D=M
@4
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

// add
@SP
AM=M-1
D=M
A=A-1
M=D+M

// add
@SP
AM=M-1
D=M
A=A-1
M=D+M

// add
@SP
AM=M-1
D=M
A=A-1
M=D+M

// return
@LCL
D=M
@Frame
M=D
@5
A=D-A
D=M
@Ret
M=D
@SP
AM=M-1
D=M
@ARG
A=M
M=D
@ARG
D=M
@SP
M=D+1
@Frame
A=M-1
D=M
@THAT
M=D
@Frame
D=M
@2
A=D-A
D=M
@THIS
M=D
@Frame
D=M
@3
A=D-A
D=M
@ARG
M=D
@Frame
D=M
@4
A=D-A
D=M
@LCL
M=D
@Ret
A=M
0;JMP

// function Sys.add12 0
(SYS.ADD12)

// push constant 4002
@4002
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

// push constant 5002
@5002
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

// push argument 0
@ARG
D=M
@0
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1

// push constant 12
@12
D=A
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

// return
@LCL
D=M
@Frame
M=D
@5
A=D-A
D=M
@Ret
M=D
@SP
AM=M-1
D=M
@ARG
A=M
M=D
@ARG
D=M
@SP
M=D+1
@Frame
A=M-1
D=M
@THAT
M=D
@Frame
D=M
@2
A=D-A
D=M
@THIS
M=D
@Frame
D=M
@3
A=D-A
D=M
@ARG
M=D
@Frame
D=M
@4
A=D-A
D=M
@LCL
M=D
@Ret
A=M
0;JMP
