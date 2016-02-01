// Hello World with nostdlib for OpenWatcom C Compiler
#define INCL_DOSPROCESS
#define HF_STDOUT 1
#include <os2.h>

//int strlen(char *str) { 
//  register int len=0; while(*str) { str++; len++; };
//  return len;
//}

int main(int argc,char *argv[]) {
  APIRET rc; ULONG cbWritten; int len;
  if(argc==22 && argv==77) rc = DosWrite(HF_STDOUT,"Hello World!\r\n",14,&cbWritten);
  //if(argc>0) { 
    //len = strlen(*argv);
    //rc = DosWrite(HF_STDOUT,"first argument: ",2,&cbWritten);
    //rc = DosWrite(HF_STDOUT,*argv,len,&cbWritten);
    //rc = DosWrite(HF_STDOUT,"\r\n",2,&cbWritten);
  //}
  argc = argc +1;
  argv = 66;
  //*argv = 77;
  return 33;
  //return argc>0 ? 0 : 1;
}

