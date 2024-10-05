/*
 * file: readt.c
 * This program tests the 32-bit read_doubles() assembly procedure.
 * It reads the doubles from stdin. 
 * (Use redirection to read from file.)
 * Driver for readm.asm
 *
 * To create executable:
 * nasm -f elf64 read.asm
 * gcc -no-pie -o readt read.o readt.c
 */

#include <stdio.h>

//#include "cdecl.h"

extern int read_doubles( double *, FILE *, int );

#define MAX 100

int main()
{
  int i,n;
  double a[MAX];

  n = read_doubles(a, stdin, MAX);

  for( i=0; i < n; i++ )
    printf("%3d %g\n", i, a[i]);

  return 0;
}
