#define INCL_DOSFILEMGR
#define INCL_DOSERRORS
#include <os2.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <locale.h>
#include <ctype.h>

ULONG attr = FILE_NORMAL|FILE_HIDDEN|FILE_SYSTEM|FILE_READONLY|FILE_DIRECTORY;
#define MaxFiles 4
#define ev "\033[0;31m"
#define nv "\033[0m"

char *progname;
char* DirMeWhat="*"; BOOL onHeapDMW=FALSE;

void help() {
  char *npn = strrchr(progname,'\\');
  printf("%s pattern - list for files and directorys extensively\n", npn?npn+1:progname );
  printf("  --creation/access/write-time^>=year-mm-dd_hh:mm:ss\n"
         "    seconds need to be multiple of two\n"
         "  -l, -ll, -1: long, very long or short format\n"
         "  -r, -p: dir recursive; praefix with path (when not recursive) or not (recursive)"
         );
  // extend for same options as allfiles where applicable 
  // have a --long option to show access date&time & all other dates&times & all extended attr names
}

UCHAR staticPathPfx[CCHMAXPATHCOMP]; UCHAR *pathpfx=staticPathPfx; ULONG pathpfxMaxLen=sizeof(staticPathPfx);
CHAR *prnpathpfx=""; ULONG pathpfxlen;
BOOL recursive = FALSE, printpraefix = FALSE; // printpraefix sets *pathpfx in prepareTarget
CHAR PathSep = '\\';
BOOL bracketdir = TRUE;  // wrap [dirnames] in brackets

#define realloc_pathpfx(pfxlen) realloc2(pfxlen,staticPathPfx,&pathpfx,&pathpfxMaxLen)
#ifndef min
  #define min(a,b) ((a)<=(b)?(a):(b))
#endif

void realloc2(ULONG newlen, UCHAR *staticbuf, UCHAR **curbufp, ULONG *maxlenp) {
  UCHAR *newbuf; ULONG attemptedlen;
  if(newlen<=*maxlenp) return;
  newbuf = realloc(*curbufp, attemptedlen=min(newlen,*maxlenp*2) );
  if(newbuf!=NULL) {
    *curbufp = newbuf; *maxlenp = attemptedlen; 
    return;
  }
  newbuf = realloc(*curbufp, newlen);
  if(newbuf==NULL) {
    fprintf(stderr,"heap: out of memory"); 
    DosExit(EXIT_PROCESS,4);
  }
  *curbufp = newbuf; *maxlenp = newlen;  
}


void printerrorcode(APIRET rc) {
  static APIRET preverr=0; if(rc==preverr) return; else preverr=rc;  // two times called: one traversial only for directories
  switch(rc) {
    case ERROR_FILE_NOT_FOUND: fprintf(stderr,"file '%s' not found.\n",DirMeWhat); break;
    case ERROR_PATH_NOT_FOUND: fprintf(stderr,"directory '%s' not found.\n",DirMeWhat); break;
    case ERROR_DRIVE_LOCKED: fprintf(stderr,"error: drive locked.\n"); break;
    case ERROR_FILENAME_EXCED_RANGE: fprintf(stderr,"filename '%s' seems to long (range_exceed).\n",DirMeWhat); break;
    default: fprintf(stderr,"unknown error #%i has occured\n", (int)rc); break;
  }
}

void qerror_chdir(APIRET ret, PSZ dirname) {
  fprintf(stderr,"chdir failed with error code %li on %s\n.", ret, dirname );
  DosExit(EXIT_PROCESS,5);
}

void qerror_defdisk(APIRET ret,ULONG disk) {
  fprintf(stderr,"DosSetDefaultDisk failed with error code %li on %c\n.", ret, (int)disk+'A'-1 );
  DosExit(EXIT_PROCESS,6);
}

char* fmtAttr(ULONG attr) {
  static char fmt[6]; int n=0;
  if( attr & FILE_SYSTEM ) fmt[n++]='S';
  if( attr & FILE_HIDDEN ) fmt[n++]='H';
  if( attr & FILE_READONLY ) fmt[n++]='R';
  if( attr & FILE_ARCHIVED ) fmt[n++]='A';
  if(!n) fmt[n++]='.';
  fmt[n]=0;
  return fmt;
}

typedef struct SCondDateTime {
  FDATE date; FTIME timestamp; USHORT cond;
} TCondDateTime;

#define t timestruct->timestamp
#define d timestruct->date
void parse_time(TCondDateTime *timestruct, char *datetime, USHORT strictcmp) {
  int fields; unsigned short int year,month,day, hours=0, minutes=0, secs=0;
  fields = sscanf(datetime, "%hu-%hu-%hu_%hu:%hu:%hu", &year, &month, &day, &hours, &minutes, &secs);
  d.day=day; d.month=month; d.year=year-1980; t.twosecs=secs>>1; t.minutes=minutes; t.hours=hours; 
  if( fields!=3 && fields!=5 && fields!=6 ) {
    fprintf(stderr,"%s invalid datetime specification '%s'.\n%s",ev,datetime,nv); timestruct->cond = 0; }
  else timestruct->cond = 1 + strictcmp;        // cond=1 bzw. strictcmp=0 -> '<='      // cond=2 bzw. strictcmp=1 -> '<'
}                                                         // cond=0 -> immer TRUE
#undef d
#undef t

BOOL cmpdate_min(TCondDateTime *base, FDATE *date, FTIME *timestamp) {
  if( ! base->cond ) return TRUE;
  //printf("%hu-%hu-%hu  %hu-%hu-%hu\n", base->date.year,base->date.month, base->date.day, date->year, date->month, date->day );
  if( base->date.year != date->year ) return ( base->date.year <= date->year );
  if( base->date.month != date->month ) return ( base->date.month <= date->month );
  if( base->date.day != date->day ) return ( base->date.day <= date->day );
  if( base->timestamp.hours != timestamp->hours ) return ( base->timestamp.hours <= timestamp->hours );
  if( base->timestamp.minutes != timestamp->minutes ) return ( base->timestamp.minutes <= timestamp->minutes );
  if( base->timestamp.twosecs != timestamp->twosecs ) return ( base->timestamp.twosecs <= timestamp->twosecs );
  return base->cond == 1;
}

signed char longformat = 0;
TCondDateTime min_access, min_creation, min_write;
TCondDateTime max_access, max_creation, max_write;

void printheading() { switch(longformat) {
  case 0: printf(" attr  creation  last-write    allocsz exact-size filename\n"); break;
  case 1: printf(" attr  creation  last-write lst-access    allocsz exact-size filename\n"); break;
  case 2: printf(" attr            creation          last-write         last-access    allocsz exact-size filename\n"); break;
}}

void findfiles(char *mask,ULONG attrs);

void processfiles(FILEFINDBUF3 *file,ULONG nfiles) {
  BOOL isdir, issubdir, shouldprint, asdir; char *name; FDATE *acc, *wri, *cre; FTIME *tacc, *twri, *tcre;
  ULONG olddirlen; APIRET ret;
  for(;nfiles;nfiles--) { isdir = file->attrFile & FILE_DIRECTORY; name = file->achName;
    acc=&(file->fdateLastAccess); wri=&(file->fdateLastWrite); cre=&(file->fdateCreation); 
    tacc=&(file->ftimeLastAccess); twri=&(file->ftimeLastWrite); tcre=&(file->ftimeCreation); 
    //shouldprint = !( isdir && name[0]=='.' && ( (name[1]=='.'&&!name[2]) || !name[1] ) );
    issubdir = isdir && !( name[0]=='.' && ( (name[1]=='.'&&!name[2]) || !name[1] ) );
    shouldprint = !isdir || issubdir;  asdir = isdir && bracketdir;
    shouldprint = shouldprint && cmpdate_min(&min_access,acc,tacc) && cmpdate_min(&min_creation,cre,tcre) && cmpdate_min(&min_write,wri,twri);
    if(shouldprint) switch(longformat) {
     case -1: printf("%s%s%s%s\n", prnpathpfx, asdir?"[":"", file->achName, asdir?"]":"" ); break;
     case 0:
       printf( "%5s %04i-%02i-%02i %04i-%02i-%02i %10li %10li %s%s%s%s\n", fmtAttr(file->attrFile),
               cre->year+1980, cre->month, cre->day,   wri->year+1980, wri->month, wri->day,
               file->cbFileAlloc, file->cbFile, prnpathpfx, asdir?"[":"", file->achName, asdir?"]":"" ); break;
     case 1:
       printf( "%5s %04hu-%02hu-%02hu %04hu-%02hu-%02hu %04hu-%02hu-%02hu %10li %10li %s%s%s%s\n", fmtAttr(file->attrFile),
               cre->year+1980, cre->month, cre->day,  
               wri->year+1980, wri->month, wri->day,
               acc->year+1980, acc->month, acc->day,
               file->cbFileAlloc, file->cbFile, prnpathpfx, asdir?"[":"", file->achName, asdir?"]":"" ); break;
     case 2:
       printf( "%5s %04hu-%02hu-%02hu_%02hu:%02hu:%02hu %04hu-%02hu-%02hu_%02hu:%02hu:%02hu %04hu-%02hu-%02hu_%02hu:%02hu:%02hu %10li %10li %s%s%s%s\n", fmtAttr(file->attrFile),
               cre->year+1980, cre->month, cre->day, tcre->hours, tcre->minutes, tcre->twosecs*2,
               wri->year+1980, wri->month, wri->day, twri->hours, twri->minutes, twri->twosecs*2,
               acc->year+1980, acc->month, acc->day, tacc->hours, tacc->minutes, tacc->twosecs*2,
               file->cbFileAlloc, file->cbFile, prnpathpfx, asdir?"[":"", file->achName, asdir?"]":"" ); break;
    }
    if(issubdir&&recursive) {
      olddirlen = pathpfxlen;
      ret = DosSetCurrentDir( (PSZ) file->achName ); if(ret) qerror_chdir(ret, (PSZ) file->achName);
      //printf("##%s\n",file->achName);
      realloc_pathpfx(pathpfxlen+file->cchName+1);
      memcpy(pathpfx+pathpfxlen, file->achName, file->cchName); pathpfxlen+=file->cchName; 
      pathpfx[pathpfxlen++]=PathSep; pathpfx[pathpfxlen]='\000'; 

      findfiles( "*", attr | MUST_HAVE_DIRECTORY );
      findfiles( "*", attr & ! FILE_DIRECTORY );

      ret = DosSetCurrentDir( (PSZ) ".." ); if(ret) qerror_chdir(ret,(PSZ)"..");
      pathpfxlen = olddirlen; pathpfx[pathpfxlen] = '\000';
    }
    file=(FILEFINDBUF3*) ( (PCHAR)file + file->oNextEntryOffset );
  }
}

void findfiles(char *mask,ULONG attrs) {
  FILEFINDBUF3 filesfound[MaxFiles];
  ULONG nfiles; APIRET rc; HDIR hdir;
  hdir=HDIR_CREATE; nfiles=MaxFiles;    // HDIR_SYSTEM ... no second lsdir ever in progress
  rc = DosFindFirst((PCSZ)mask,&hdir,attrs,filesfound,sizeof(filesfound),&nfiles,FIL_STANDARD);
  if(!rc) processfiles(filesfound,nfiles);
  while( !rc ) { nfiles=MaxFiles;
    rc =  DosFindNext( hdir, filesfound, sizeof(filesfound), &nfiles );
    if(!rc) processfiles(filesfound,nfiles);
  }
  if(rc!=ERROR_NO_MORE_FILES) printerrorcode(rc);
  DosFindClose(hdir);
}

PUCHAR pwd( ULONG letter, ULONG *wdlength, ULONG excess ) {
  APIRET ret; ULONG length=0; PSZ buf;
  ret = DosQueryCurrentDir( letter, NULL, &length );
  if(ret!=ERROR_BUFFER_OVERFLOW) { fprintf(stderr,"DosQueryCurrentDir failed to return buffer length with error code #%li.\n",ret); DosExit(EXIT_PROCESS,2); }
  buf = malloc(length+excess+3); buf[0]='A'-1+letter; buf[1]=':'; buf[2]='\\';
  ret = DosQueryCurrentDir( letter, buf+3, &length );
  if(ret) { fprintf(stderr,"DosQueryCurrentDir failed with error code #%li.\n",ret); DosExit(EXIT_PROCESS,3); }
  if(wdlength) *wdlength = length +2;   // \000 at the end is included in length
  return buf;
}

BOOL listcontent=TRUE;

char* PrepareTarget(ULONG *drive, UCHAR **path, char **mask, char *tg,BOOL *onHeap) {
  ULONG len; BOOL hasExcess=FALSE; BOOL isadir=FALSE; char *newtg,*cp,*dp; ULONG pfxlen,masklen;
  len = masklen = strlen(tg);
  isadir= tg[len-1]=='\\' || tg[len-1]=='/';
  if( tg[len-1]==':' ) {
    BOOL isdrive=TRUE, err=FALSE; char letter;
    if(len!=2) { err=TRUE; isdrive = strchr(tg,'/')==NULL && strchr(tg,'\\')==NULL; }
    else { letter=toupper(*tg); err= letter<'A' || letter>'Z'; }
    if(err) { fprintf(stderr, isdrive ? "wrong drive spec: '%s'\n" : "wrong filename spec (':' used)\n", tg); DosExit(EXIT_PROCESS,1); } 
    tg = (char*)pwd(letter-'A'+1,&len,2); *onHeap=hasExcess=TRUE; isadir=TRUE;
  }
  if( !isadir ) {
    FILESTATUS3 nodeinfo; APIRET ret;
    ret = DosQueryPathInfo( (PSZ)tg, FIL_STANDARD, &nodeinfo, sizeof(nodeinfo) );    
    if( ret && ret!=ERROR_INVALID_PATH && ret!=ERROR_PATH_NOT_FOUND && ret!=ERROR_FILE_NOT_FOUND) { 
      fprintf(stderr,"warning: DosQueryPathInfo/FIL_STANDARD returned %li for %s\n", ret, tg); }
    isadir = !ret && nodeinfo.attrFile & FILE_DIRECTORY;
  }
  if( isadir && listcontent ) {
    if(!hasExcess) { newtg=malloc(len+2); strncpy(newtg,tg,len+1); tg=newtg; *onHeap=hasExcess=TRUE; }
    if( tg[len-1]!='\\' && tg[len-1]!='/' ) { tg[len++]='\\'; masklen++; }
    pfxlen = len-1; // do not include trailing \; SetDir would not like that; however reserve space for it and term. \000.
    tg[len++]='*'; tg[len]='\000'; masklen++;
  } else if( printpraefix || recursive ) {
    if( !listcontent && len>0 && ( tg[len-1]=='\\' || tg[len-1]=='/' ) ) len--; // lst -d /temp/ -> ls -d /temp
    for( cp=tg+len; --cp>=tg; ) if( *cp=='\\' || *cp=='/' ) break;
    pfxlen = cp - tg;
  }
  printf("<<%s,%li>>\n",tg,pfxlen);
  if( printpraefix || recursive ) { 
    realloc_pathpfx( pfxlen+2 ); pathpfxlen=pfxlen;
    for( cp=tg, dp=(char*)pathpfx; pfxlen; pfxlen--, cp++, dp++ ) if( *cp=='/' || *cp=='\\' ) *dp = PathSep; else *dp=*cp;
    if( pathpfxlen==0 || ( pathpfxlen==2 && pathpfx[1]==':' ) ) { *dp = PathSep; dp++; }  // -> x:\ oder \: add \ if path empty
    *dp = '\000'; 
    printf("<<%s,%li>>\n",pathpfx,pathpfxlen);
    if( pathpfxlen>1 && pathpfx[1]==':' ) { *path = pathpfx+2; *drive=toupper(pathpfx[0])-'A'+1; }
    else { *path = pathpfx; *drive=0; }
    *mask = tg + pathpfxlen + 1; masklen -= pathpfxlen+1; if(**mask=='\000') { *mask="*"; masklen=1; }
  } else {
    *path = NULL; *mask = tg; drive=0;
  }
  //printf("&<%s,%li>\n",*mask,masklen);
  if( masklen>0 && ( (*mask)[masklen-1]=='\\' || (*mask)[masklen-1]=='/' ) ) {
    masklen--;
    if(hasExcess) (*mask)[masklen]='\000';
    else { newtg=malloc(masklen+1); memcpy(newtg,*mask,masklen); newtg[masklen]='\000'; *mask=newtg;  }
  }
  if( printpraefix ) prnpathpfx = (char*)pathpfx; else prnpathpfx = "";
  return tg;
}

BOOL hasarg(int argc,char* param) {
  if(argc<2) fprintf(stderr,"%sparameter value expected for %s.%s\n",ev,param,nv);
  return argc>=2;
}

BOOL plainnames = FALSE;

void processShortOpts(char *opts) {
  while(*opts) {
    switch(*opts) {
      case 'h': help(); DosExit(EXIT_PROCESS,0);
      case 'l': longformat++; break;
      case '1': longformat--; break;
      case 'd': listcontent=FALSE; break;
      case 'r': recursive=TRUE; break;
      case 'p': plainnames=TRUE; break;
      case 'u': PathSep='/'; break;
      case 'c': bracketdir=FALSE; break;
      default: fprintf(stderr,"%sunknown option -%c.%s\n",ev,*opts,nv);
    }; opts++;
  }
}

int main(int argc, char *argv[]) {
  ULONG drive; PSZ path; char *mask; PSZ cwd=NULL; ULONG cd=0; APIRET ret; ULONG drivemap;
  argc--; progname=*argv; argv++;
  min_access.cond = min_creation.cond = min_write.cond = 0;
  max_access.cond = max_creation.cond = max_write.cond = 0;
  while(argc&&argv[0][0]=='-') { 
    if(!strcmp(*argv,"-h")|!strcmp(*argv,"--help")) { help(); return 0; } else
    if( (*argv)[0]=='-' && (*argv)[1]!='\000' && (*argv)[1]!='-') processShortOpts(*argv+1); else
    if(!strncmp(*argv,"--access-time>=",15)) parse_time(&min_access, *argv+15, 0 ); else
    if(!strncmp(*argv,"--creation-time>=",17)) parse_time(&min_creation, *argv+17, 0 ); else
    if(!strncmp(*argv,"--write-time>=",14)) parse_time(&min_write, *argv+14, 0 ); else
    if(!strncmp(*argv,"--access-time>",14)) parse_time(&min_access, *argv+14, 0 ); else
    if(!strncmp(*argv,"--creation-time>",16)) parse_time(&min_creation, *argv+16, 0 ); else
    if(!strncmp(*argv,"--write-time>",13)) parse_time(&min_write, *argv+13, 0 ); else
    fprintf(stderr,"%sunknown option %s!%s\n",ev,*argv,nv);
    argc--; argv++; 
  }
  printpraefix = recursive ^ plainnames;
  do {
    if(argc--) DirMeWhat=argv++[0];     ret=0;
    DirMeWhat = PrepareTarget( &drive, &path, &mask, DirMeWhat, &onHeapDMW );
    if( path ) {
      if(!cwd) { DosQueryCurrentDisk( &cd, &drivemap ); cwd = pwd(cd,NULL,0); }
      if(drive!=0) { ret = DosSetDefaultDisk( drive );
                      if( ret==ERROR_INVALID_DRIVE ) { fprintf(stderr,"invalid drive: %c #%i\n",(char)drive+'A'-1,(int)drive); if(argc>0) continue; else break; } }
      if(!ret) { ret = DosSetCurrentDir( path );
                 if( ret==ERROR_PATH_NOT_FOUND ) { fprintf(stderr,"path not found: '%s'\n",path); if(argc>0) continue; else { DosSetDefaultDisk(cd); break; } } }
      // now add the stripped trailing \ again to make it seeable in the output
      if( pathpfxlen>0 && pathpfx[pathpfxlen-1]!='\\' ) { pathpfx[pathpfxlen++]=PathSep; pathpfx[pathpfxlen]='\000'; }
    }
    printf("<<%s#%s>>\n",path,mask);
    if(!ret) {
      printheading();                                                                             
      findfiles( mask, attr | MUST_HAVE_DIRECTORY );        // recommendation: not to use the MUST_HAVE flags
      findfiles( mask, attr & ! FILE_DIRECTORY );
      if( path ) {
        ret = DosSetDefaultDisk( cd ); if(ret) qerror_defdisk(ret,cd);
        ret = DosSetCurrentDir( cwd ); if(ret) qerror_chdir(ret,cwd);  }
    }
    if(onHeapDMW) free(DirMeWhat);
  } while (argc>0);
  return 0;
}


