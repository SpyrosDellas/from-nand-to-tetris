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
// push constant 0 
@0 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// pop local 0 
@LCL 
D=M 
@0 
D=D+A 
@R13 
M=D 
@SP 
AM=M-1 
D=M 
@R13 
A=M 
M=D 

// label LOOP_START 
(BASICLOOP.$LOOP_START) 

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

// add 
@SP 
AM=M-1 
D=M 
A=A-1 
M=D+M 

// pop local 0 
@LCL 
D=M 
@0 
D=D+A 
@R13 
M=D 
@SP 
AM=M-1 
D=M 
@R13 
A=M 
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

// pop argument 0 
@ARG 
D=M 
@0 
D=D+A 
@R13 
M=D 
@SP 
AM=M-1 
D=M 
@R13 
A=M 
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

// if-goto LOOP_START 
@SP 
AM=M-1 
D=M 
@BASICLOOP.$LOOP_START 
D; JNE 

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

