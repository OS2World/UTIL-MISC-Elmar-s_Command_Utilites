// Hello World with nostdlib for OpenWatcom C Compiler
#define INCL_DOSPROCESS
#define HF_STDOUT 1
#include <os2.h>
#include <stdlib.h>

void main(void) {
  APIRET rc; PVOID myhighmem,myheap; ULONG cbWritten;
  rc = DosWrite(HF_STDOUT,"Hello World!\r\n",14,&cbWritten);
  myheap = malloc(256); if(myheap) printf("heap alloc ok\r\n");
  rc = DosAllocMem(&myhighmem, 1024*1024*1024, PAG_READ|PAG_WRITE | OBJ_ANY );  // allocate 1GB of HMA(obj_any) rw-able 
  if(rc==0) { rc = DosWrite(HF_STDOUT,"allocation ok.!\r\n",17,&cbWritten);
    rc = DosFreeMem(myhighmem);
  }
  free(myheap);
  DosExit(EXIT_PROCESS,rc);
}
