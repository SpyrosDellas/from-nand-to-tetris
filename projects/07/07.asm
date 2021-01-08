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
// push constant 10 
@10 
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

// push constant 21 
@21 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// push constant 22 
@22 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// pop argument 2 
@ARG 
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

// pop argument 1 
@ARG 
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

// push constant 36 
@36 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// pop this 6 
@THIS 
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

// push constant 42 
@42 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// push constant 45 
@45 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// pop that 5 
@THAT 
D=M 
@5 
D=D+A 
@R13 
M=D 
@SP 
AM=M-1 
D=M 
@R13 
A=M 
M=D 

// pop that 2 
@THAT 
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

// push constant 510 
@510 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// pop temp 6 
@SP 
AM=M-1 
D=M 
@R11 
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

// push that 5 
@THAT 
D=M 
@5 
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

// push this 6 
@THIS 
D=M 
@6 
A=D+A 
D=M 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// push this 6 
@THIS 
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

// sub 
@SP 
AM=M-1 
D=M 
A=A-1 
M=M-D 

// push temp 6 
@R11 
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

// push constant 111 
@111 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// push constant 333 
@333 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// push constant 888 
@888 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// pop static 8 
@SP 
AM=M-1 
D=M 
@StaticTest.8 
M=D 

// pop static 3 
@SP 
AM=M-1 
D=M 
@StaticTest.3 
M=D 

// pop static 1 
@SP 
AM=M-1 
D=M 
@StaticTest.1 
M=D 

// push static 3 
@StaticTest.3 
D=M 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// push static 1 
@StaticTest.1 
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

// push static 8 
@StaticTest.8 
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

