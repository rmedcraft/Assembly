/*
 * file: memex.c
 * Driver file for memory.asm file
 * To create executable:
 * nasm -f elf64 memory.asm
 * gcc -no-pie -o memex memory.o memex.c
 */

#include <stdio.h>

//#include "cdecl.h"

#define STR_SIZE 30
/*
 * prototypes
 */

void asm_copy( void *, const void *, unsigned );

void * asm_find( const void *, char target, unsigned );

unsigned asm_strlen( const char * );

void asm_strcpy( char *, const char * );

int main()
{
  char st1[STR_SIZE] = "test string";
  char st2[STR_SIZE];
  char * st;
  char   ch;

  asm_copy(st2, st1, STR_SIZE);   /* copy all 30 chars of string */
  printf("%s\n", st2);

  printf("Enter a char: ");  /* look for byte in string */
  scanf("%c%*[^\n]", &ch);
  getchar(); // string newline from stdin
  st = asm_find( st2, ch, STR_SIZE);
  if ( st )
    printf("Found it: %s\n", st);
  else
    printf("Not found\n");
  
  st1[0] = 0;
  printf("Enter string: ");
  scanf("%[^\n]", st1);
  printf("len = %u\n", asm_strlen(st1));

  asm_strcpy( st2, st1);     /* copy meaningful data in string */
  printf("%s\n", st2 );

  return 0;
}
