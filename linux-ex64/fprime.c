/*
 * file: fprime.c
 * This program calculates prime numbers
 * Driver file for prime2.asm file
 * To create executable:
 * nasm -f elf64 prime2.asm
 * gcc -no-pie -o fprime prime2.o fprime.c
 */

#include <stdio.h>
#include <stdlib.h>

/*
 * function find_primes
 * finds the indicated number of primes
 * Parameters:
 *   a - array to hold primes
 *   n - how many primes to find
 */
extern void find_primes( int * a, unsigned n );

int main()
{
  int status;
  unsigned i;
  unsigned max;
  int * a;

  printf("How many primes do you wish to find? ");
  scanf("%u", &max);

  a = calloc( sizeof(int), max);

  if ( a ) {

    find_primes(a,max);

    /*
     * print out the last 20 primes found
     */
    for(i= ( max > 20 ) ? max - 20 : 0; i < max; i++ )
      printf("%3d %d\n", i+1, a[i]);

    free(a);
    status = 0;
  }
  else {
    fprintf(stderr, "Can not create array of %u ints\n", max);
    status = 1;
  }

  return status;
}
