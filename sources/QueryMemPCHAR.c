// by Elmar Stellnberger 2013-04
// available under GPL
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
  assert( (PCHAR)&(mem.maxShrd) - (void*)&(mem.physical) == sizeof(ULONG) * 4 );
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
  if( DosAllocMem( &mymem, 4096*3, PAG_READ ) ) err("allocerr");
  memObjSize = (ULONG)LMA; flags = 0;
  if( DosQueryMem( mymem, &memObjSize, &flags) ) err("queryerr");
  printf("%p: size=%li, flags=%s\n", mymem, memObjSize, flags2str(flags));
  memObjSize = (ULONG)LMA; flags = 0;
  if( DosQueryMem( (PCHAR)mymem+4096, &memObjSize, &flags) ) err("queryerr");
  printf("%p: size=%li, flags=%s\n", (PCHAR)mymem+4096, memObjSize, flags2str(flags));
  DosFreeMem(mymem);
  memObjSize = (ULONG)LMA; flags = 0;
  if( DosQueryMem( mymem, &memObjSize, &flags) ) err("queryerr");
  printf("%p: size=%li, flags=%s\n", mymem, memObjSize, flags2str(flags));
}

PVOID MemRegionStart(PCHAR ptr) {
  ULONG memObjSize,flags; APIRET ret;
  ptr = 0; flags = 0; memObjSize = (ULONG)LMA;
  while(( ret = DosQueryMem( ptr, &memObjSize, &flags ) && ptr < LMA )) { 
    if(ret!=ERROR_INTERRUPT) ptr += PageSize; memObjSize = (ULONG)LMA; flags = 0;
  }
  return ptr;
}

int AlyMemRegion(PCHAR start, PCHAR *endregion, ULONG *maxblock, ULONG *summem, ULONG *wholemem) {
  ULONG maxbl=0, sumbl=0, wholebl=0; PCHAR end=*endregion, ptr=start; int err=0;
  ULONG memObjSize,flags; APIRET ret;
  while( ptr < end ) {
    memObjSize = end - ptr; flags = 0;
    do {
      do { ret = DosQueryMem( ptr, &memObjSize, &flags ); } while (ret==ERROR_INTERRUPT);

      if(ret==ERROR_INVALID_ADDRESS) {
        ptr += PageSize; wholebl += PageSize; memObjSize=end-ptr; flags=0; continue;
      }
    } while (ret==ERROR_INVALID_ADDRESS);
    if(ret) { *endregion = ptr; printf("!!!!#%i\n",(int)ret); break; }
    if( flags & PAG_FREE ) {
      maxbl = max(maxbl,memObjSize); sumbl += memObjSize;
    }
    ptr += memObjSize;
  }
  *maxblock = maxbl; *summem = sumbl; *wholemem = wholebl;
  return err;
}

int main(int argc, char *argv[]) {
  PCHAR startLMA, endLMA; ULONG lmaMax, lmaSum, lmaWhole;
  PCHAR startHMA, endHMA; ULONG hmaMax, hmaSum, hmaWhole;
  getMemAttr();

  printf("                             total physical memory: %s\n", n2r(mem.physical) );
  printf("                                residential memory: %s\n", n2r(mem.residential) );
  printf("          total memory available for all processes: %s\n", n2r(mem.avail4proc) );
  printf("maximal low memory available for a certain process: %s\n", n2r(mem.maxProc) );
  printf("               maximal available low shared memory: %s\n", n2r(mem.maxShrd) );
  printf("                             virtual address limit: %s\n", n2r(mem.VirtAdrLimit) );
  //freefmt();

  startLMA = 0; endLMA = LMA; // startLMA = MemRegionStart((void*)0); 
  AlyMemRegion( startLMA, &endLMA, &lmaMax, &lmaSum, &lmaWhole);
  printf("lmaMax=%s, lmaSum=%s, lmaWhole=%s\n",n2r(lmaMax),n2r(lmaSum),n2r(lmaWhole));
  printf("start=%p, end=%p, firstpage=%x\n", startLMA, endLMA, (unsigned)PageSize );

  startHMA = LMA; endHMA = (void*)mem.VirtAdrLimit; //LMA + mem.VirtAdrLimit;
  AlyMemRegion( startHMA, &endHMA, &hmaMax, &hmaSum, &hmaWhole);
  printf("hmaMax=%s, hmaSum=%s, hmaWhole=%s\n",n2r(hmaMax),n2r(hmaSum),n2r(hmaWhole));
  printf("start=%p, end=%p, firstpage=%x\n", startHMA, endHMA, (unsigned)PageSize );

  //freefmt();
  //queryself();

//  printf("start=%p, end=%p, sz=%li\n",&firstMemObj,memObjSize);
//  rc = DosQueryMem( &firstMemObj, &memObjSize, &flags);
// printf("ret=%i, sz=%li\n",(int)rc,memObjSize);
  return 0;
}

