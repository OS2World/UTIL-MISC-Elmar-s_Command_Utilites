// by Elmar Stellnberger 2013-04/09
// available under GPL
// version 0.3
// download at: http://www.elstel.org/OS2Warp/os2utils.html

#define INCL_DOSMEMMGR
#define INCL_DOSMISC
#define INCL_DOSERRORS
#include <os2.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>

#undef min
#undef max
#define min(a,b) ((a)<=(b)?(a):(b))
#define max(a,b) ((a)>=(b)?(a):(b))
#define PVOID PCHAR


char *progname;

void help() {
  char *npn = strrchr(progname,'\\');
  printf("%s [lma|hma|attr|PagSz=4096|VirtAdrLim=??]*\r\n", npn?npn+1:progname );
  printf("     VirtAdrLim=2048 ... assume a VirtualAddressLimit of 2048 in config.sys (valid if attr not given)\r\n" \
         "    PagSz=4096 ... do not query for the PageSize; use this fixed constant (valid if attr not given)\r\n");
  DosExit(EXIT_PROCESS,0);
}

void err(const char *msg) {
  fprintf(stderr,msg); DosExit(EXIT_PROCESS,1);
}
const char *qsi = "Error Calling DosQuerySysInfo\n";

ULONG PageSize;
struct {
  ULONG physical, residential, avail4proc, maxProc, maxShrd;
  ULONG VirtAdrLimit;
} mem;

void getMemAttr() {
  assert( (PVOID)&(mem.maxShrd) - (PVOID)&(mem.physical) == sizeof(ULONG) * 4 );
  if( DosQuerySysInfo( QSV_PAGE_SIZE, QSV_PAGE_SIZE, &(PageSize), sizeof(ULONG) ) ) err(qsi);
  if( DosQuerySysInfo( QSV_TOTPHYSMEM, QSV_MAXSHMEM, &(mem.physical), 5*sizeof(ULONG) ) ) err(qsi);
  if( DosQuerySysInfo( QSV_VIRTUALADDRESSLIMIT, QSV_VIRTUALADDRESSLIMIT, &(mem.VirtAdrLimit), sizeof(ULONG) ) ) err(qsi);
  mem.VirtAdrLimit <<= 20;
}

struct FmtStr { char *s; struct FmtStr *next; };
struct FmtStr *firstfmtstr = NULL;
typedef struct FmtStr TFmtStr;

char* fmt(char *s,int fmtlen) {
  int i; int len = strlen(s); TFmtStr *newfmtstr;
  char *result = malloc( max(len,fmtlen)+1 );
  for(i=0;i<fmtlen-len;i++) result[i]=' ';
  strcpy( result + max(0,fmtlen-len), s);
  newfmtstr = malloc( sizeof(TFmtStr) );
  newfmtstr->s = result; newfmtstr->next = firstfmtstr; firstfmtstr = newfmtstr;
  return result;
}

void dofree(TFmtStr *fmtstr) {
  if(fmtstr->next) dofree(fmtstr->next);
  free(fmtstr->s); free(fmtstr);
}

void freefmt() {
  if(firstfmtstr) dofree(firstfmtstr);
  firstfmtstr = NULL;
}

char* n2r(ULONG n) {
  char* suffix[] = { "", "K", "M", "G" };
  static char buf[64]; int i=0, rem=0;
  while( n >= 1024 && i < 3 ) {
   rem = ((n >> 4) * 10 ) >> 5;  n >>= 10; rem = (rem+1 - (n<<1)*10) >> 1; i+=1; 
  }
  sprintf( buf, "%li.%i%s", n, rem, suffix[i] );  //printf("%s",buf);
  return fmt(buf,0);
}

PVOID LMA = (void*)0x20000000;

char* flags2str(ULONG flags) {
  ULONG flagvals[] = { PAG_COMMIT, PAG_FREE, PAG_SHARED, PAG_BASE, PAG_READ, PAG_WRITE, PAG_EXECUTE, PAG_GUARD };
  char* flagstrs[] = { "PAG_COMMIT", "PAG_FREE", "PAG_SHARED", "PAG_BASE", "PAG_READ", "PAG_WRITE", "PAG_EXECUTE", "PAG_GUARD" };
  static char buf[256]; int i; int num = sizeof(flagvals) / sizeof(ULONG); buf[0]=0;
  for(i=0; i<num; i++ ) {
    if( flags & flagvals[i] ) { if(buf[0]) strcat(buf,", "); strcat(buf,flagstrs[i]); }
  }
  return buf;
}

void queryself() {
  PVOID mymem; ULONG memObjSize,flags;
  // only reserve virtual memory; do not allocate with fALLOC
  if( DosAllocMem( (void**)&mymem, 4096*3, PAG_READ ) ) err("allocerr");
  memObjSize = (ULONG)LMA; flags = 0;
  if( DosQueryMem( mymem, &memObjSize, &flags) ) err("queryerr");
  printf("%p: size=%li, flags=%s\n", mymem, memObjSize, flags2str(flags));
  memObjSize = (ULONG)LMA; flags = 0;
  if( DosQueryMem( mymem+4096, &memObjSize, &flags) ) err("queryerr");
  printf("%p: size=%li, flags=%s\n", mymem+4096, memObjSize, flags2str(flags));
  DosFreeMem(mymem);
  memObjSize = (ULONG)LMA; flags = 0;
  if( DosQueryMem( mymem, &memObjSize, &flags) ) err("queryerr");
  printf("%p: size=%li, flags=%s\n", mymem, memObjSize, flags2str(flags));
}

PVOID MemRegionStart(PVOID ptr) {
  ULONG memObjSize,flags; APIRET ret;
  ptr = 0; flags = 0; memObjSize = (ULONG)LMA;
  while(( ret = DosQueryMem( ptr, &memObjSize, &flags ) && ptr < LMA )) { 
    if(ret!=ERROR_INTERRUPT) ptr += PageSize; memObjSize = (ULONG)LMA; flags = 0;
  }
  return ptr;
}

int AlyMemRegion(PVOID start, PVOID *endregion, ULONG *maxblock, ULONG *summem, ULONG *wholemem) {
  ULONG maxbl=0, sumbl=0, wholebl=0; PVOID end=*endregion, ptr=start; int err=0;
  ULONG memObjSize,flags; APIRET ret;
  while( ptr < end ) {
    memObjSize = end - ptr; flags = 0;
    do {
      do { ret = DosQueryMem( ptr, &memObjSize, &flags ); } while (ret==ERROR_INTERRUPT);

      if(ret==ERROR_INVALID_ADDRESS) {
        ptr += PageSize; wholebl += PageSize; memObjSize=end-ptr; flags=0; continue;
      }
    } while (ret==ERROR_INVALID_ADDRESS);
    // not caught: 87 ERROR_INVALID_PARAMETER - kernel 085
    if(ret) { *endregion = ptr; 
      if (ret==ERROR_INVALID_PARAMETER) printf("!!! QueryMem returned INVALID_PARAMETER on address %p; (memory area may not have been set up correctly by OS/2s memory managment) \n",ptr);
      else printf("!!!! DosQueryMem returned #%i\n",(int)ret);
      break;
    }
    if( flags & PAG_FREE ) {
      maxbl = max(maxbl,memObjSize); sumbl += memObjSize;
    }
    ptr += memObjSize;
  }
  *maxblock = maxbl; *summem = sumbl; *wholemem = wholebl;
  return err;
}

int AlyMemArena(PVOID start, PVOID *endregion, ULONG *privatearea, ULONG *sharedarea, ULONG *freearea) {
  PVOID ptr=start, end=*endregion; ULONG priv=0, shared=0, unused=0, whole=0;
  ULONG memObjSize,flags; APIRET ret; int err=0;

  while( ptr < end ) {

    memObjSize = end - ptr; flags = 0; whole=0;
    do {
      do { ret = DosQueryMem( ptr, &memObjSize, &flags ); } while (ret==ERROR_INTERRUPT);

      if( ret==ERROR_INVALID_ADDRESS || ret==ERROR_INVALID_PARAMETER ) {
        ptr += PageSize; whole += PageSize; memObjSize=end-ptr; flags=0; continue;
      }
    } while (ret==ERROR_INVALID_ADDRESS || ret==ERROR_INVALID_PARAMETER );

    if(whole>0) printf(" whole=%s\n",n2r(whole));
    if( flags & PAG_FREE ) {
      unused = memObjSize;
      break;
    } else {
      priv += memObjSize;
      ptr += memObjSize;
    }

  }
  printf(" privatarena=%s\n",n2r(priv));

  while( ptr < end ) {

    memObjSize = end - ptr; flags = 0; whole=0;
    do {
      do { ret = DosQueryMem( ptr, &memObjSize, &flags ); } while (ret==ERROR_INTERRUPT);

      if( ret==ERROR_INVALID_ADDRESS || ret==ERROR_INVALID_PARAMETER ) {
        ptr += PageSize; whole += PageSize; memObjSize=end-ptr; flags=0; continue;
      }
    } while (ret==ERROR_INVALID_ADDRESS || ret==ERROR_INVALID_PARAMETER );

    if(whole>0) printf(" whole=%s\n",n2r(whole));
    if( !(flags & PAG_FREE) ) {
      shared = memObjSize;
      break;
    } else {
      unused += memObjSize;
      ptr += memObjSize;
    }

  }
  printf(" freearea=%s\n",n2r(unused));

  while( ptr < end ) {

    memObjSize = end - ptr; flags = 0; whole=0;
    do {
      do { ret = DosQueryMem( ptr, &memObjSize, &flags ); } while (ret==ERROR_INTERRUPT);

      if( ret==ERROR_INVALID_ADDRESS || ret==ERROR_INVALID_PARAMETER ) {
        ptr += PageSize; whole += PageSize; memObjSize=end-ptr; flags=0; continue;
      }
    } while (ret==ERROR_INVALID_ADDRESS || ret==ERROR_INVALID_PARAMETER );

    if(whole>0) printf(" whole=%s\n",n2r(whole));
    if( flags & PAG_FREE ) {
      ptr +=memObjSize;
      //printf("unallocated space in shared area=%li\n", memObjSize); 
    } else {
      shared += memObjSize;
      ptr += memObjSize;
    }

  }
  printf(" sharedarena=%s\n",n2r(shared));

    // not caught: 87 ERROR_INVALID_PARAMETER - kernel 085
    if(ret) { *endregion = ptr; 
      if (ret==ERROR_INVALID_PARAMETER) printf("!!! QueryMem returned INVALID_PARAMETER on address %p; (memory area may not have been set up correctly by OS/2s memory managment) \n",ptr);
      else printf("!!!! DosQueryMem returned #%i\n",(int)ret);
      ;
    }
  return err;
}



// commited (PAG_COMMIT) and decommited (0) pages: look at PAG_SHARED
// PAG_FREE: do not conside PAG_SHARED

void PrintArea(ULONG *arealength, BOOL *isshared, ULONG memObjSize, BOOL nextshared, ULONG *freelength, ULONG *lastfree,
                  ULONG *commitlength, BOOL memObjSizeIsCommited) {
  printf(" %sarena=%s (free:%2i%%, commited:%2i%%)", *isshared ? "shared" : "private", n2r(*arealength+*freelength),
          (int)( *freelength*100/(*arealength+*freelength) ),  (int)( *commitlength*100/(*arealength+*freelength) )  );
  if(*lastfree>0) printf(", freearea=%s", n2r(*lastfree) );
  printf("\r\n"); freefmt();
  *arealength = memObjSize; *isshared = nextshared; *freelength = 0; *lastfree = 0;
  *commitlength = memObjSizeIsCommited ? memObjSize : 0;
}

void* PrintAnalyseArea(PVOID ptr, PVOID end) {

  ULONG memObjSize,flags, whole; APIRET ret;  
  BOOL isshared = FALSE, nextshared=FALSE;
  ULONG arealength = 0, lastfree = 0, freelength = 0, commitlength = 0;

  while( ptr < end ) {

    memObjSize = end - ptr; flags = 0; whole=0;
    do {
      do { ret = DosQueryMem( ptr, &memObjSize, &flags ); } while (ret==ERROR_INTERRUPT);

      if( ret==ERROR_INVALID_ADDRESS || ret==ERROR_INVALID_PARAMETER ) {
        ptr += PageSize; whole += PageSize; memObjSize=end-ptr; flags=0; //continue;
      }
    } while ( ( ret==ERROR_INVALID_ADDRESS || ret==ERROR_INVALID_PARAMETER ) && ptr < end );
    // whole
    // memObjSize,flags

    if(whole>0) {
      if(arealength>0) PrintArea( &arealength, &isshared, memObjSize, flags & PAG_SHARED, &freelength, &lastfree, 
                                        &commitlength, flags & PAG_COMMIT  );
      printf(" whole=%s\n",n2r(whole)); freefmt();
      //ptr += memObjSize;
      //continue;
    }

    if( flags & PAG_FREE ) {
      freelength += lastfree;
      lastfree = memObjSize;
      if(flags & PAG_SHARED) putchar('!');  // we assume this is not possible: pages are either unallocated, private or shared
    } else {
      nextshared = flags & PAG_SHARED; 
      if( isshared == nextshared ) {
        arealength += memObjSize;
        if( flags & PAG_COMMIT ) commitlength += memObjSize;
      } else {
        if(arealength>0) PrintArea( &arealength, &isshared, memObjSize, nextshared, &freelength, &lastfree,
                                           &commitlength, flags & PAG_COMMIT );
      }
    }
    ptr += memObjSize;

  }

   PrintArea( &arealength, &isshared, memObjSize, TRUE, &freelength, &lastfree,
                 &commitlength, flags & PAG_COMMIT  );

  return ptr;

}





int main(int argc, char *argv[]) {
  PVOID startLMA, endLMA; ULONG lmaMax, lmaSum, lmaWhole;
  PVOID startHMA, endHMA; ULONG hmaMax, hmaSum, hmaWhole;
  //ULONG privatearena, sharedarena, freearena;
  BOOL printLMA=FALSE, printHMA=FALSE, printMEMattr=FALSE, VirtAdrLimSet=FALSE, PagSzSet=FALSE;

  progname=*argv; argc--; argv++;
  if(argc<=0) {
    printLMA=TRUE, printHMA=TRUE, printMEMattr=TRUE;
  } else {
    while(argc) { char *arg=*argv;
      if(arg[0]=='-' && arg[1]=='-') arg+=2; 
      if(!strcasecmp(arg,"lma")) printLMA=TRUE; else
      if(!strcasecmp(arg,"hma")) printHMA=TRUE; else
      if(!strcasecmp(arg,"attr")) printMEMattr=TRUE; else
      if(!strncasecmp(arg,"VirtAdrLim=",11)) { mem.VirtAdrLimit=atoi(arg+11)<<20; VirtAdrLimSet=mem.VirtAdrLimit!=0; } else
      if(!strncasecmp(arg,"PagSz=",6)) { PageSize = atoi(arg+6); PagSzSet=PageSize>0; } else
      if(!strcasecmp(arg,"help")) help(); else
      fprintf(stderr,"unbekannte option %s\r\n",*argv);
      argc--; argv++;
    }
  }

  if(printMEMattr) getMemAttr(); else {
    if( !PagSzSet )  { if( DosQuerySysInfo( QSV_PAGE_SIZE, QSV_PAGE_SIZE, &(PageSize), sizeof(ULONG) ) ) err(qsi); }
    if( !VirtAdrLimSet && printHMA ) { if( DosQuerySysInfo( QSV_VIRTUALADDRESSLIMIT, QSV_VIRTUALADDRESSLIMIT, &(mem.VirtAdrLimit), sizeof(ULONG) ) ) err(qsi);
                                              mem.VirtAdrLimit <<= 20; };
  }

  if(printMEMattr) {
    printf("                             total physical memory: %s\n", n2r(mem.physical) );
    printf("     residential memory (locked by device drivers): %s\n", n2r(mem.residential) );
    printf("          total memory available for all processes: %s\n", n2r(mem.avail4proc) );
    printf("       maximum low private memory for this process: %s\n", n2r(mem.maxProc) );
    printf("               maximal available low shared memory: %s\n", n2r(mem.maxShrd) );
    printf("                             virtual address limit: %s\n", n2r(mem.VirtAdrLimit) );
    printf("\r\n"); freefmt();
  }

  if(printLMA) {
    startLMA = 0; endLMA = LMA; // startLMA = MemRegionStart((void*)0); 
    AlyMemRegion( startLMA, &endLMA, &lmaMax, &lmaSum, &lmaWhole);
    printf("lmaMax=%s, lmaSum=%s, lmaWhole=%s\n",n2r(lmaMax),n2r(lmaSum),n2r(lmaWhole));
    printf("start=%p, end=%p, pagesize=%x\n", startLMA, endLMA, (unsigned)PageSize ); freefmt();
    startLMA = 0; endLMA = LMA;
    //AlyMemArena( startLMA, &endLMA, &privatearena, &sharedarena, &freearena);
    //printf("--LMA--\n");
    PrintAnalyseArea(0,LMA);
    printf("\r\n");
  }

  if(printHMA) {
    startHMA = LMA; endHMA = (void*)mem.VirtAdrLimit; //LMA + mem.VirtAdrLimit;
    AlyMemRegion( startHMA, &endHMA, &hmaMax, &hmaSum, &hmaWhole);
    printf("hmaMax=%s, hmaSum=%s, hmaWhole=%s\n",n2r(hmaMax),n2r(hmaSum),n2r(hmaWhole));
    printf("start=%p, end=%p, pagesize=%x\n", startHMA, endHMA, (unsigned)PageSize );  freefmt();
    PrintAnalyseArea(startHMA,(void*)mem.VirtAdrLimit);
    printf("\r\n");
  }

  //freefmt();
  //queryself();

//  printf("start=%p, end=%p, sz=%li\n",&firstMemObj,memObjSize);
//  rc = DosQueryMem( &firstMemObj, &memObjSize, &flags);
// printf("ret=%i, sz=%li\n",(int)rc,memObjSize);
  return 0;
}

