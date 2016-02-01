// shutdown-console: close all file handles
#define INCL_DOSFILEMGR
#define INCL_DOSPROCESS
#define HF_STDOUT 1
#include <os2.h>

int main(int argc, char *argv[]) {
  APIRET rc; ULONG cbWritten;
  DosWrite(HF_STDOUT,"executing DosShutdown ...; you may now turn off your computer.\r\n",63,&cbWritten);
  if(rc) DosWrite(HF_STDOUT,"DosShutdown returned an error.\r\n",31,&cbWritten);
  DosExit(EXIT_PROCESS,rc);
  return rc;
}
