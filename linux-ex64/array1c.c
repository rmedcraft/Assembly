/*
 * Driver file for array1.asm file
 * To create executable:
 * nasm -f elf64 array1.asm
 * gcc -no-pie array1.o array1c.c -o array1
 */

#include <stdio.h>

int asm_main( void );
void dump_line( void );

int main()
{
  int ret_status;
  ret_status = asm_main();
  return ret_status;
}

/*
 * function dump_line
 * dumps all chars left in current line from input buffer
 */
void dump_line()
{
  int ch;

  while( (ch = getchar()) != EOF && ch != '\n')
    /* null body*/ ;
}

