/*
 * file: quadt.c
 * Test file for quad.asm
 * To create executable:
 * nasm -f elf64 quad.asm
 * gcc -no-pie -o quadt quad.o quadt.c
 */

#include <stdio.h>

int quadratic( double, double, double, double *, double *);

int main()
{
  double a,b,c, root1, root2;
  int result;
  printf("Enter a, b, c: ");
  scanf("%lf %lf %lf", &a, &b, &c);
  result=quadratic( a, b, c, &root1, &root2);
  if ( result )
    printf("roots: %.10g %.10g\n", root1, root2);
  else
    printf("No real roots\n");
  return 0;
}

