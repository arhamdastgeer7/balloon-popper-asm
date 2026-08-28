# Balloon Popper — x86 Assembly Game

Balloon Popper is a real time typing game written entirely in x86 
Assembly using BIOS interrupts. No libraries. No engine. No shortcuts. 
Every pixel, every sound, every game mechanic built from scratch at 
the lowest level possible.

## How it works
Balloons rise up the screen, each carrying a random letter. Type the 
matching letter before the balloon hits the ceiling. Miss one and 
it's game over. The faster you type, the higher your score.

## Features
- Real-time balloon movement using custom delay loops
- Random letter generation using a Linear Congruential Generator
- Sound effect on every successful pop via direct port I/O
- Pop animation effect when a balloon is destroyed
- Balloon respawn system — a new balloon spawns immediately after each pop
- Performance rating on game over — Nice Try, Well Done, or Amazing Reflexes
- Full game state machine — menu, gameplay, game over, restart

## Difficulty Levels
Three levels selectable from the main menu:

- Beginner — 5 balloons, slow speed
- Medium — 6 balloons, medium speed  
- Advanced — 7 balloons, fast speed

Speed is controlled through calibrated NOP delay loops, each level 
progressively reducing the delay to increase balloon rise speed.

## Tech Stack
- x86 Assembly 
- BIOS Interrupts — INT 10h for display, INT 16h for keyboard, INT 1Ah for timer
- Direct Port I/O — port 61h for PC speaker sound
- DOS INT 21h for program exit
- DOSBox for running the executable

## What makes this hard
In Assembly there are no functions, no loops, no data types just 
registers, memory addresses and interrupts. Printing a single colored 
character takes multiple lines. Drawing a balloon on screen requires 
manually positioning the cursor for every single row. Every feature 
that would take one line in Python took 20-30 lines in Assembly.

## Course
Computer Organization and Assembly Language, 3rd Semester, FAST NUCES
