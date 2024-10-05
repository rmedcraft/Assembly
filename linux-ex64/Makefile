#
# Linux makefile
# Use with make
#
# This wants gcc, g++, and gdb
# To enable debuggin, change the setting for the DEBUG variable below
# from 0 to 1
#

DEBUG	:= 0
ifeq ($(DEBUG), 1)
ADEBUG	:= -g
CDEBUG	:= -ggdb
endif
AS	:= nasm
CC	:= gcc
CXX	:= g++
ASFLAGS := -f elf64 $(ADEBUG)
CFLAGS	:= $(CDEBUG)
CXXFLAGS := $(CDEBUG)
LDFLAGS := -no-pie $(CDEBUG)
TARGETS := array1 bitcount bitcount2 dmaxt first fprime math max memex prime quadt readt sub1 sub2 sub3 sub4 sub5 sub6 test_big_int
DEP1 := driver.o
DEP2 := driver.o asm_io.o

.PHONY: clean

%.o: %.asm
	$(AS) $(ASFLAGS) $<

all: $(TARGETS)

asm_io.o: asm_io.asm
	$(AS) $(ASFLAGS) -d ELF_TYPE asm_io.asm

array1: array1c.o



dmaxt: dmax.o

first: $(DEP2)

fprime: prime2.o

math: $(DEP1)

max: $(DEP1) max.o

memex: memory.o

prime: $(DEP1)

quadt: quad.o

readt: read.o

sub1: $(DEP1)

sub2: $(DEP1)

sub3: $(DEP1)

sub4: $(DEP1) main4.o

sub5: main5.o asm_io.o

sub6: main6.o

test_big_int : test_big_int.o big_int.o big_math.o
	$(CXX) $(CXXFLAGS) -o test_big_int test_big_int.o big_int.o big_math.o

big_int.o: big_int.hpp

first.o: asm_io.inc

sub5.o: asm_io.inc

test_big_int.o: big_int.hpp

clean :
	rm -f *.o $(TARGETS)
