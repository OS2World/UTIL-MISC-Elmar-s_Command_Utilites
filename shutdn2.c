// shutdown-console: close all file handles
#define INCL_DOSFILEMGR
#define INCL_DOSPROCESS
#define HF_STDOUT 1
#include <os2.h>

#define EXPORTED __attribute__((__visibility__("default")))
//int c=0xba0bab;
//int zero=0;

//#pragma weak WEAK$ZERO
//int WEAK$ZERO(void) { return 0; }

//#pragma GCC visibility push(default)

int __argc;

int _cstart_(int argc, char *argv[]) {
  APIRET rc; ULONG cbWritten;
  DosWrite(HF_STDOUT,"executing DosShutdown ...; you may now turn off your computer.\r\n",63,&cbWritten);
  rc = 1; //DosShutdown(0);
  if(rc) DosWrite(HF_STDOUT,"DosShutdown returned an error.\r\n",31,&cbWritten);
  DosExit(EXIT_PROCESS,rc);
  return rc;
}
