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
// push constant 17 
@17 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// push constant 17 
@17 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// eq 
@EQ1 
D=A 
@EQ 
0;JMP 
(EQ1) 

// push constant 17 
@17 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// push constant 16 
@16 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// eq 
@EQ2 
D=A 
@EQ 
0;JMP 
(EQ2) 

// push constant 16 
@16 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// push constant 17 
@17 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// eq 
@EQ3 
D=A 
@EQ 
0;JMP 
(EQ3) 

// push constant 892 
@892 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// push constant 891 
@891 
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

// push constant 891 
@891 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// push constant 892 
@892 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// lt 
@LT2 
D=A 
@LT 
0;JMP 
(LT2) 

// push constant 891 
@891 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// push constant 891 
@891 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// lt 
@LT3 
D=A 
@LT 
0;JMP 
(LT3) 

// push constant 32767 
@32767 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// push constant 32766 
@32766 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// gt 
@GT1 
D=A 
@GT 
0;JMP 
(GT1) 

// push constant 32766 
@32766 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// push constant 32767 
@32767 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// gt 
@GT2 
D=A 
@GT 
0;JMP 
(GT2) 

// push constant 32766 
@32766 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// push constant 32766 
@32766 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// gt 
@GT3 
D=A 
@GT 
0;JMP 
(GT3) 

// push constant 57 
@57 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// push constant 31 
@31 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// push constant 53 
@53 
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

// push constant 112 
@112 
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

// neg 
@SP 
A=M-1 
M=-M 

// and 
@SP 
AM=M-1 
D=M 
A=A-1 
M=D&M 

// push constant 82 
@82 
D=A 
@SP 
A=M 
M=D 
@SP 
M=M+1 

// or 
@SP 
AM=M-1 
D=M 
A=A-1 
M=D|M 

// not 
@SP 
A=M-1 
M=!M 

