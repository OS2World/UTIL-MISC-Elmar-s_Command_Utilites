#include <stdio.h>


int main(int argc, char *argv[]) {
  int i=0;
  while(i<10) {
    i++;
    continue;
  }
  printf("final value of i = %i\r\n", i );
  return 0;
}


