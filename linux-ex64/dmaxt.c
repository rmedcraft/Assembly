/*
 * Driver file for dmax.asm file
 * To create executable:
 * nasm -f elf64 dmax.asm
 * gcc -no-pie dmaxt.c dmax.o -o dmaxt
 */
#include <stdio.h>

double dmax( double, double );

int main()
{
  double d1, d2;

  printf("Enter two doubles: ");
  scanf("%lf %lf", &d1, &d2);

  printf("The larger of %g and %g is %g\n", d1, d2, dmax(d1,d2));
  return 0;
}

