// BOOTSTRAP CODE - SYS.INIT 
@256 
D=A 
@SP 
M=D 
// call SYS.INIT 0 
@SYS.$RET.1 
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
@SYS.INIT 
0;JMP 
(SYS.$RET.1) 

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

// function Main.fibonacci 0 
(MAIN.FIBONACCI) 

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

// push constant 2 
@2 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// lt 
@LT1 
D=A 
@LT 
0;JMP 
(LT1) 

// if-goto IF_TRUE 
@SP 
AM=M-1 
D=M 
@MAIN.FIBONACCI$IF_TRUE 
D; JNE 

// goto IF_FALSE 
@MAIN.FIBONACCI$IF_FALSE 
0;JMP 

// label IF_TRUE 
(MAIN.FIBONACCI$IF_TRUE) 

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

// label IF_FALSE 
(MAIN.FIBONACCI$IF_FALSE) 

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

// push constant 2 
@2 
D=A 
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

// call Main.fibonacci 1 
@MAIN.FIBONACCI$RET.1 
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
@MAIN.FIBONACCI 
0;JMP 
(MAIN.FIBONACCI$RET.1) 

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

// push constant 1 
@1 
D=A 
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

// call Main.fibonacci 1 
@MAIN.FIBONACCI$RET.2 
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
@MAIN.FIBONACCI 
0;JMP 
(MAIN.FIBONACCI$RET.2) 

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

// function Sys.init 0 
(SYS.INIT) 

// push constant 10 
@10 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// call Main.fibonacci 1 
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
@6 
D=D-A 
@ARG 
M=D 
@SP 
D=M 
@LCL 
M=D 
@MAIN.FIBONACCI 
0;JMP 
(SYS.INIT$RET.1) 

// label WHILE 
(SYS.INIT$WHILE) 

// goto WHILE 
@SYS.INIT$WHILE 
0;JMP 

