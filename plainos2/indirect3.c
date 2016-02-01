// Hello World with nostdlib for OpenWatcom C Compiler
#define INCL_DOSPROCESS
#define HF_STDOUT 1
#include <os2.h>

void cmain(void) {
  APIRET rc; PVOID myhighmem; ULONG cbWritten;
  rc = DosWrite(HF_STDOUT,"Hello World!\r\n",14,&cbWritten);
  rc = DosAllocMem(&myhighmem, 1024*1024*1024, PAG_READ|PAG_WRITE | OBJ_ANY );  // allocate 1GB of HMA(obj_any) rw-able 
  if(rc==0) { rc = DosWrite(HF_STDOUT,"allocation ok.!\r\n",17,&cbWritten);
    rc = DosFreeMem(myhighmem);
  }
  DosExit(EXIT_PROCESS,rc);
}
