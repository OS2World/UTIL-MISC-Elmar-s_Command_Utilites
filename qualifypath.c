#define INCL_DOSFILEMGR
#define INCL_DOSERRORS
#include <os2.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <locale.h>
#include <ctype.h>

ULONG attr = FILE_NORMAL|FILE_HIDDEN|FILE_SYSTEM|FILE_READONLY|FILE_DIRECTORY;
ULONG dirattr = FILE_NORMAL|FILE_HIDDEN|FILE_SYSTEM|FILE_READONLY|FILE_DIRECTORY;
#define MaxFiles 4
#define ev "\033[0;31m"
#define nv "\033[0m"

char *progname;
char* DirMeWhat="*"; BOOL onHeapDMW=FALSE;

void help() {
  char *npn = strrchr(progname,'\\');
  printf("%s path\n", npn?npn+1:progname );
  printf("  returns the fully qualified path name for path\n"
         "  -u  use unix directory separators\n"
         );
  // extend for same options as allfiles where applicable 
  // have a --long option to show access date&time & all other dates&times & all extended attr names
}

CHAR staticPath[CCHMAXPATHCOMP]; CHAR *path=staticPath; ULONG pathMaxLen=sizeof(staticPath);
CHAR PathSep = '\\';

#define realloc_path(len) realloc1(len,staticPath,&path,&pathMaxLen)
#ifndef min
  #define min(a,b) ((a)<=(b)?(a):(b))
#endif

void realloc1(ULONG newlen, CHAR *staticbuf, CHAR **curbufp, ULONG *maxlenp) {
  CHAR *newbuf;
  if(newlen<=*maxlenp) return;
  newbuf = realloc(*curbufp, newlen);
  if(newbuf==NULL) {
    fprintf(stderr,"heap: out of memory"); 
    DosExit(EXIT_PROCESS,4);
  }
  *curbufp = newbuf; *maxlenp = newlen;  
}


void printerrorcode(APIRET rc, char* argv) {
  switch(rc) {
    case ERROR_INVALID_NAME: fprintf(stderr,"ERROR_INVALID_NAME: you may have used invalid characters in '%s'\n",argv); break;
    default: fprintf(stderr,"unknown error #%i qualifying file- or pathname '%s' has occured\n", (int)rc, argv); break;
  }
}


BOOL plainnames = FALSE;

void processShortOpts(char *opts) {
  while(*opts) {
    switch(*opts) {
      case 'h': help(); DosExit(EXIT_PROCESS,0);
      case 'u': PathSep='/'; break;
      default: fprintf(stderr,"%sunknown option -%c.%s\n",ev,*opts,nv);
    }; opts++;
  }
}

int main(int argc, char *argv[]) {
  APIRET rc; char *cp;
  argc--; progname=*argv; argv++;

  while(argc&&argv[0][0]=='-') { 
    if(!strcmp(*argv,"-h")|!strcmp(*argv,"--help")) { help(); return 0; } else
    if( (*argv)[0]=='-' && (*argv)[1]!='\000' && (*argv)[1]!='-') processShortOpts(*argv+1); else
    fprintf(stderr,"%sunknown option %s!%s\n",ev,*argv,nv);
    argc--; argv++; 
  }

  while(argc) {
    rc = DosQueryPathInfo( (PSZ)*argv, FIL_QUERYFULLNAME, path, pathMaxLen );
    while( rc == ERROR_BUFFER_OVERFLOW ) {
      realloc_path(pathMaxLen+128);
      rc = DosQueryPathInfo( (PSZ)*argv, FIL_QUERYFULLNAME, path, pathMaxLen );
    }
    if(rc) printerrorcode(rc,*argv);
    else {
      if( PathSep!='\\' ) for(cp=path; *cp; cp++) if(*cp=='\\') *cp=PathSep;
      printf(path); printf("\r\n"); 
    }
    argc--; argv++;
  }

  return 0;
}


