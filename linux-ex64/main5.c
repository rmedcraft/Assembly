/*
 * file: main5.c
 * main C program that uses assembly routine in sub5.asm
 * to create executable:
 * To build:
 *        nasm -f elf64 sub5.asm
 *        gcc -no-pie -o sub5 main5.c sub5.o asm_io.o
 */

#include <stdio.h>

void calc_sum( int, int * ); /* prototype for assembly routine */

int main( void )
{
  int n, sum;

  printf("Sum integers up to: ");
  scanf("%d", &n);
  calc_sum(n, &sum);
  printf("Sum is %d\n", sum);
  return 0;
}
