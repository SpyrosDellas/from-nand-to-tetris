// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed.
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.


// Set screen=0. This represents white, the starting state of the screen
@screen
M=0

// Set screensize = 8192. This is the number of different addresses
// of the screen memory
@8192
D=A
@screensize
M=D

// Initialize counter i = 0
@i
M=0

// -------------------------------------------------------------------------
// Infinite keyboard scan loop
(LOOP)

  @KBD
  D=M    // Get current keyboard memory register value

  // if KBD != 0 goto BLACKEN (a key is pressed)
  @BLACKEN
  D; JNE

  // else goto WHITEN
  @WHITEN
  0; JMP

@LOOP
0; JMP


// -------------------------------------------------------------------------
(BLACKEN)
// if screen == 1, goto LOOP
@screen
D=M;
@LOOP
D=D-1; JEQ

// else blacken screen

// PSEUDO CODE
// while i < screensize
//  @SCREEN+i
//  M=0
//  i++

(BLACKLOOP)
  // if i == screensize goto CONTINUE1
  @screensize
  D=M
  @i
  D=D-M
  @CONTINUE1
  D; JEQ

  // Set screen memory register SCREEN+i to zero
  @i
  D=M
  @SCREEN
  A=A+D
  M=-1      // Blacks selected screen register
  @i
  M=M+1    // i+=1

@BLACKLOOP
0; JMP

(CONTINUE1)
// set current screen state
@screen
M=1

// reset i and goto LOOP
@i
M=0
@LOOP
0; JMP


// -------------------------------------------------------------------------
(WHITEN)
// if screen == 0, goto LOOP
@screen
D=M;
@LOOP
D; JEQ

// else whiten screen
(WHITELOOP)
  // if i == screensize goto CONTINUE2
  @screensize
  D=M
  @i
  D=D-M
  @CONTINUE2
  D; JEQ

  // Set screen memory register SCREEN+i to 1111...
  @i
  D=M
  @SCREEN
  A=A+D
  M=0     // Whitens selected screen register
  @i
  M=M+1    // i+=1

@WHITELOOP
0; JMP

(CONTINUE2)
// set current screen state
@screen
M=0

// reset i and goto LOOP
@i
M=0
@LOOP
0; JMP
