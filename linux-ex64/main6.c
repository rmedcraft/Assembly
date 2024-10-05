/*
 * file: main6.c
 * main C program that uses assembly routine in sub5.asm
 * to create executable:
 *     nasm -f elf64 sub6.asm
 *     gcc -no-pie -o sub6 main6.c sub6.o
 */

#include <stdio.h>

int calc_sum( int );     /* prototype for assembly routine */

int main( void )
{
  int n, sum;

  printf("Sum integers up to: ");
  scanf("%d", &n);
  sum = calc_sum(n);
  printf("Sum is %d\n", sum);
  return 0;
}
