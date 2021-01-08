// BOOTSTRAP CODE - BYPASSES EQ, GT, LT TEMPLATE CODE BLOCK 
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
// function SimpleFunction.test 2 
(SIMPLEFUNCTION.TEST) 
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

// add 
@SP 
AM=M-1 
D=M 
A=A-1 
M=D+M 

// not 
@SP 
A=M-1 
M=!M 

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

// add 
@SP 
AM=M-1 
D=M 
A=A-1 
M=D+M 

// push argument 1 
@ARG 
D=M 
@1 
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

