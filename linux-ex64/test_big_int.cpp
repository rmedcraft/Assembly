/*
 * file: big_int_test.cpp
 * A small test program for the Big_int class
 *
 * To build:
 * GCC:   nasm -f elf64 big_math.asm
 *        g++ -no-pie -o test_big_int big_math.o big_int.cpp test_big_int.cpp
 */
#include "big_int.hpp"
#include <iostream>

using namespace std;

int main()
{
  try {
    //           12345678901234567890
    Big_int b(5,"8000000000000a00b");
    Big_int a(5,"80000000000010230");
    Big_int c = a + b;
    cout << "a + b = c" << endl
	 << a << " + " << b << " = " << c << endl;
    for( int i=0; i < 2; i++ ) {
      c = c + a;
      cout << "c = c + a = " << c << endl;
    }
    cout << "c-1 =       " << c - Big_int(5,1) << endl;
    Big_int d(5, "12345678");
    cout << "d = " << d << endl;
    cout << "c == d " << (c == d) << endl;
    cout << "c > d " << (c > d) << endl;
  }
  catch( const char * str ) {
    cerr << "Caught: " << str << endl;
  }
  catch( Big_int::Overflow ) {
    cerr << "Overflow" << endl;
  }
  catch( Big_int::Size_mismatch ) {
    cerr << "Size mismatch" << endl;
  }
  return 0;
}
