// Hello World with nostdlib for OpenWatcom C Compiler
#define INCL_DOSPROCESS
#define HF_STDOUT 1
#include <os2.h>

void _plainmain_(void) {
  APIRET rc; ULONG cbWritten;
  rc = DosWrite(HF_STDOUT,"Hello World!\r\n",14,&cbWritten);
  DosExit(EXIT_PROCESS,rc);
}
