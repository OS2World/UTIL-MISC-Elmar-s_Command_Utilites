
#include <stdio.h>
#include <os2.h>

UCHAR pathbuf[256];

int main(int argc, char *argv[]) {
  APIRET rc; ULONG pathactlen;
  while(argc) { printf("%s\r\n",*argv); argv++; argc--; }
  pathactlen=256;
  rc = DosQueryCurrentDir( 0, pathbuf, &pathactlen );
  if(!rc) printf("%s\r\n",pathbuf);
  getchar();
  return 0;
}
