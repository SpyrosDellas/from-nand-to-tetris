// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)
//
// We assume that R0>=0, R1>=0, and R0*R1<32768.
//
// A 16 bit integer in the 2s complement representation can store
// only 0..32767 positive integers
//
// *** PSEUDO CODE ***
//
// int1 = RAM[0]
// int2 = RAM[1]
// shifted = RAM[0]
// mask = 1
// i = 0
// RAM[2] = 0
//
// while i < 15:
//   if (int2 & mask) != 0:          // check if the ith digit of int2 is 1
//     RAM[2] = RAM[2] + shifted
//   endif
//   shifted = shifted + shifted   // Equals to 2*shifted, i.e. shifted << 1
//   mask = mask + mask            // Equals to 2*mask, i.e. mask << 1
//   i += 1
//
// RAM[2] = result

@R0
D=M
@int1
M=D     // int1 = R0

@R1
D=M
@int2
M=D     // int2 = R1

@R0
D=M
@shifted
M=D   // shifted = R0

@mask
M=1    // mask = 1

@i
M=0    // i = 0

@R2
M=0    // RAM[2] = 0

(LOOP)
  // if i == 15 goto END
  @15
  D=A
  @i
  D=D-M
  @END
  D; JEQ

  // if (int2 & mask) == 0 goto CONTINUE
  @int2
  D=M
  @mask
  D=D&M
  @CONTINUE
  D; JEQ

  // Update result
  @R2
  D=M
  @shifted
  D=D+M
  @R2
  M=D

  (CONTINUE)
  @shifted
  D=M
  M=D+M  // shifted = shifted + shifted
  @mask
  D=M
  M=D+M  // mask = mask + mask
  @i
  D=M
  M=D+1  // i += 1

@LOOP
0; JMP

(END)
@END
0; JMP
