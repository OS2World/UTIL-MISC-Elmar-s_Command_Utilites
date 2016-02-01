// by Elmar Stellnberger 2013-09-19
// available under GPL
#include <stdio.h>
#include <stdlib.h>

const void *LMA = (void*)0x20000000;

void printRegionOf(char *regionname, void *ptr) {
  printf("%s: %s (%p)\r\n", regionname, ptr<=LMA ? "LMA" : "HMA", ptr );
}

int incint(int a) {
  return a+1;
}

int globalint;

void printRegionAlloc() {
  int localint;
  void *myproc = incint;
  void *mylocal = &localint;
  void *myglobal = &globalint;
  void *mydynamic = malloc(32);
  printRegionOf(" code segment", myproc);
  printRegionOf("stack segment", mylocal);
  printRegionOf(" data segment", myglobal);
  printRegionOf(" heap segment", mydynamic);
  free(mydynamic);
}

int main(int argc, char *argv[]) {
  printRegionAlloc();
  return 0;
}

