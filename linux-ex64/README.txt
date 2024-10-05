 - The Linux-ex64 Example Code Directory - 

This directory contains example programs that you should build and explore/test (examine the source code and run them). These programs demonstrate many of the concepts about NASM assembly that we will explore and learn. 

This collection of programs is designed to be built via GNU make (a build system).

To use Make to build these programs, you will need:
NASM
gcc
g++
make
gdb


NASM is the assembler - a must have.
gcc is the compiler the build the program executable - a must have.
g++ is the C++ compiler for the big_int C++ code - a must have.
make is the automated build system - a must have.
gdb is a debugger that allows you to race program execution at runtime - optional (but you'll want it!).

To make all of the example programs, do the following:

1) Change directories into the linux-ex64 directory.
2) At the command prompt, type:
	make all
3) You should see a flurry of text fly by. If all goes well, you will not see any errors.
4) You should then be able to run each program from the command line. The name of each program is listed below (along with the source code associated with the program and how you can build that program without make.
5) You can build individual programs with make by typing "make <program_name>", for example:
	make array1


EXAMPLE PROGRAMS:

array1:
	Creates & initializes an array. Prints portions of the array
	Source code: array1.asm
	Driver code: array1c.c
	To build:
	nasm -f elf64 array1.asm
	gcc -no-pie array1.o array1c.c -o array1

bitcount:
	Example code from the text.
	Count bits that are one (on) in a value.
	Source code: bitcount.c
	To build:
	gcc -o bitcount bitcount.c

bitcount2:
	Example code from the text.
	Different version, stores precomputed "on" bits  in lookup array.
	Count bits that are one (on) in a value.
	Source code: bitcount2.c
	To build:
	gcc -o bitcount2 bitcount2.c

dmaxt:
	Returns maximum of two input values.
	Source code: dmax.asm
	Driver code: dmaxt.c
	To build:
	nasm -f elf64 dmax.asm
	gcc -no-pie dmaxt.c dmax.o -o dmaxt

first:
	A very simple "first" assembly program.
	Takes two input values, returns their sum.
	Uses macros from asm_io to dump registers & memory
	Source code: first.asm
	Driver code: driver.c
	To build:
	nasm -f elf64 first.asm
	gcc -no-pie -o first first.o driver.c asm_io.o

fprime:
	Given an input value, finds that many primes.
	Source code: prime2.asm
	Driver code: prime.c
	To build:
	nasm -f elf64 prime2.asm
	gcc -no-pie -o fprime prime2.o fprime.c

math:
	Reads a value and performs some simple math.
	Demonstrates input/output via printf and scanf.
	Source code: math.asm
	Driver code:  driver.c
	To build:
	nasm -f elf64 math.asm
	gcc -no-pie -o math math.o driver.c

max:
	Finds max of two input values (without branches)
	Source code: max.asm
	Driver code: driver.c
	To build:
	nasm -f elf64 max.asm
	gcc -no-pie -o max max.o driver.c

memex:
	Demonstrates strings and string instructions
	Source code: memory.asm
	Driver code: memex.c
	To build:
	nasm -f elf64 memory.asm
 	gcc -no-pie -o memex memory.o memex.c

prime:
	Finds prime numbers up to input value
	Source code: prime.asm
	Driver code: driver.c
	To build:
	nasm -f elf64 prime.asm
	gcc -no-pie -o prime prime.o driver.c

quadt:
	Finds roots for quadratic equation
	Source code: quad.asm
	Driver code: quadt.c
	To build:
	nasm -f elf64 quad.asm
	gcc -no-pie -o quadt quad.o quadt.c

readt:
	Reads doubles from a file, returns numbers read and stored in array.
	Source code: read.asm
	Driver code: reads.c
	To build:
	nasm -f elf64 read.asm
	gcc -no-pie -o readt read.o readt.c

sub1:
	Reads two values from standard in and display their sum
	Uses a subprogram via a jump
	Source code: sub1.asm
	Driver code: driver.c
	To build:
	nasm -f elf64 sub1.asm
	gcc -no-pie -o sub1 sub1.o driver.c

sub2:
	Reads two values from standard in and display their sum
	Uses a subprogram via a call
	Source code: sub2.asm
	Driver code: driver.c
	To build:
	nasm -f elf64 sub2.asm
	gcc -no-pie -o sub1 sub2.o driver.c

sub3:
	Read in values and sum them up (similar to sub4).
	All subprograms in one file
	Source code: sub3.asm
	Driver code: driver.c
	To build:
	nasm -f elf64 sub3.asm
	gcc -no-pie -o sub1 sub3.o driver.c

sub4:
	Read in values and sum them up (similar to sub3).
	Subprograms are split across multiple files
	Source code: sub4.asm, main4.asm
	Driver code: driver.c
	To build:
	nasm -f elf64 sub4.asm
	nasm -f elf64 main4.asm
	gcc -no-pie -o sub4 sub4.o main4.o driver.c

sub5:
	sums numbers up to input value (similar to sub6).
	Interfaces assembly w/C (main5.c)
	This version uses pass-by reference.
	Uses macros from asm_io to dump registers .
	Source code: sub5.asm
	Driver code: main5.c
	To build:
	nasm -f elf64 sub5.asm
	gcc -no-pie -o sub5 main5.c sub5.o asm_io.o

sub6 
	sums numbers up to input value (similar to sub5).
	Interfaces assembly w/C (main6.c)
	This version Returns value via RAX.
	Source code: sub6.asm
	Driver code: main6.c
	To build:
	nasm -f elf64 sub6.asm
	gcc -no-pie -o sub6 main6.c sub6.o

test_big_int:
	Demonstrates interfacing assembly with C++.
	Provides assembly routines to override mathematics operators.
	Source code: big_math.asm, big_int.cpp
	Driver code: test_big_int.cpp
	To build:
	nasm -f elf64 big_math.asm
	g++ -no-pie -o test_big_int big_math.o big_int.cpp test_big_int.cpp
