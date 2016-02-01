// lsa v0.5
// (c) copyright by Elmar Stellnberger, 2013
// current email: estellnb@elstel.org, add. email: estellnb@gmail.com/yahoo.de
//
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
  printf("%s pattern - list for files and directorys extensively\n", npn?npn+1:progname );
  printf("  --creation/access/write-time^>=year-mm-dd_hh:mm:ss\n"
         "    seconds need to be multiple of two\n"
         "  -l, -ll, -1: long, very long or short format\n"
         "  -r, -p: dir recursive; praefix with path (when not recursive) or not (recursive)\n"
         "  -d: list directories themselves rather than just their content\n"
         "  -u: use unix dirseps, -c: canonical dir-printing without [brackets]\n"
         "  -f: flatten . and .. on -dr as these were part of the current dir"
         "  -s: like -1ruc"
         );
  // extend for same options as allfiles where applicable 
  // have a --long option to show access date&time & all other dates&times & all extended attr names
}

UCHAR staticPathPfx[CCHMAXPATHCOMP]; UCHAR *pathpfx=staticPathPfx; ULONG pathpfxMaxLen=sizeof(staticPathPfx);
CHAR *prnpathpfx=""; ULONG pathpfxlen, prnpathlen;
BOOL recursive = FALSE, printpraefix = FALSE; // printpraefix sets *pathpfx in prepareTarget
CHAR PathSep = '\\';
BOOL bracketdir = TRUE;  // wrap [dirnames] in brackets
BOOL flatten = FALSE;

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
  fprintf(stderr,"DosFindFirst/Next: ");
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

ULONG parseAttrs(char *attrspec) {
  ULONG attrs = 0;
  while(*attrspec) {
    switch(toupper(*attrspec)) {
      case 'S': attrs|=FILE_SYSTEM; break;      case 'H': attrs|=FILE_HIDDEN; break;
      case 'R': attrs|=FILE_READONLY; break;   case 'A': attrs|=FILE_ARCHIVED; break;
      case 'N': attrs|=FILE_NORMAL; break;       case 'D': attrs|=FILE_DIRECTORY; break;
      case 'E': case '*': attrs|=0x4000;
    }
    attrspec++;
  }
  return attrs;
}

typedef struct SCondDateTime {
  FDATE date; FTIME timestamp; USHORT fields,cond;
} TCondDateTime;

#define t timestruct->timestamp
#define d timestruct->date
void parse_time(TCondDateTime *timestruct, char *datetime, USHORT strictcmp) {
  int fields; unsigned short int year,month,day, hours=0, minutes=0, secs=0;
  fields = timestruct->fields = sscanf(datetime, "%hu-%hu-%hu_%hu:%hu:%hu", &year, &month, &day, &hours, &minutes, &secs);
  d.day=day; d.month=month; d.year=year-1980; t.twosecs=secs>>1; t.minutes=minutes; t.hours=hours; 
  if( fields!=3 && fields!=5 && fields!=6 ) {
    fprintf(stderr,"%s invalid datetime specification '%s'.\n%s",ev,datetime,nv); timestruct->cond = 0; }
  else timestruct->cond = !strictcmp;        // cond=1 bzw. strictcmp=0 -> '<='      // cond=2 bzw. strictcmp=1 -> '<'
}                                                         // cond=0 -> immer TRUE
#undef d
#undef t

BOOL cmpdate_min(TCondDateTime *base, FDATE *date, FTIME *timestamp) {
  if( base->fields==0) return base->cond;
  //printf("%hu-%hu-%hu  %hu-%hu-%hu\n", base->date.year,base->date.month, base->date.day, date->year, date->month, date->day );
  if( base->date.year != date->year ) return ( base->date.year <= date->year );
  if( base->date.month != date->month ) return ( base->date.month <= date->month );
  if( base->date.day != date->day ) return ( base->date.day <= date->day );
  if(base->fields<=3) return base->cond;
  if( base->timestamp.hours != timestamp->hours ) return ( base->timestamp.hours <= timestamp->hours );
  if( base->timestamp.minutes != timestamp->minutes ) return ( base->timestamp.minutes <= timestamp->minutes );
  if(base->fields<=5) return base->cond;
  if( base->timestamp.twosecs != timestamp->twosecs ) return ( base->timestamp.twosecs <= timestamp->twosecs );
  return base->cond;
}

#define cmpdate_max(base,date,timestamp) !cmpdate_min(base,date,timestamp)


signed char longformat = 0;
TCondDateTime min_access, min_creation, min_write;
TCondDateTime max_access, max_creation, max_write;

void printheading() { switch(longformat) {
  case -1: printf(" attr last-write exact-size filename\n"); break;
  case 0: printf(" attr  creation  last-write    allocsz exact-size filename\n"); break;
  case 1: printf(" attr  creation  last-write lst-access    allocsz exact-size filename\n"); break;
  case 2: printf(" attr            creation          last-write         last-access    allocsz exact-size filename\n"); break;
}}

void findfiles(char *mask,ULONG attrs);

void processfiles(FILEFINDBUF3 *file,ULONG nfiles,char *mask) {
  BOOL isdir, issubdir, shouldprint, asdir; char *name; FDATE *acc, *wri, *cre; FTIME *tacc, *twri, *tcre;
  BOOL dotmask = FALSE; char *filename; int namelen;
  ULONG olddirlen; APIRET ret;
  for(;nfiles;nfiles--) { isdir = file->attrFile & FILE_DIRECTORY; name = file->achName;
    acc=&(file->fdateLastAccess); wri=&(file->fdateLastWrite); cre=&(file->fdateCreation); 
    tacc=&(file->ftimeLastAccess); twri=&(file->ftimeLastWrite); tcre=&(file->ftimeCreation); 
    //shouldprint = !( isdir && name[0]=='.' && ( (name[1]=='.'&&!name[2]) || !name[1] ) );
    dotmask = mask[0]=='.' && ( (mask[1]=='.'&&!mask[2]) || !mask[1] );
    issubdir = isdir && !( name[0]=='.' && ( (name[1]=='.'&&!name[2]) || !name[1] ) );
    shouldprint = !isdir || issubdir || dotmask;  asdir = isdir && bracketdir;
    shouldprint = shouldprint && cmpdate_min(&min_access,acc,tacc) && cmpdate_min(&min_creation,cre,tcre) && cmpdate_min(&min_write,wri,twri);
    shouldprint = shouldprint && cmpdate_max(&max_access,acc,tacc) && cmpdate_max(&max_creation,cre,tcre) && cmpdate_max(&max_write,wri,twri);
    if( dotmask ) { filename=mask; namelen= mask[1] ? 2 : 1; } else { filename=file->achName; namelen=file->cchName; }
    if(shouldprint) switch(longformat) {
     case -2: printf("%s%s%s%s\n", prnpathpfx, asdir?"[":"", filename, asdir?"]":"" ); break;
     case -1:
       printf( "%5s %04i-%02i-%02i %10li %s%s%s%s\n", fmtAttr(file->attrFile),
               wri->year+1980, wri->month, wri->day, file->cbFile, prnpathpfx, asdir?"[":"", filename, asdir?"]":"" ); break;
     case 0:
       printf( "%5s %04i-%02i-%02i %04i-%02i-%02i %10li %10li %s%s%s%s\n", fmtAttr(file->attrFile),
               cre->year+1980, cre->month, cre->day,   wri->year+1980, wri->month, wri->day,
               file->cbFileAlloc, file->cbFile, prnpathpfx, asdir?"[":"", filename, asdir?"]":"" ); break;
     case 1:
       printf( "%5s %04hu-%02hu-%02hu %04hu-%02hu-%02hu %04hu-%02hu-%02hu %10li %10li %s%s%s%s\n", fmtAttr(file->attrFile),
               cre->year+1980, cre->month, cre->day,  
               wri->year+1980, wri->month, wri->day,
               acc->year+1980, acc->month, acc->day,
               file->cbFileAlloc, file->cbFile, prnpathpfx, asdir?"[":"", filename, asdir?"]":"" ); break;
     case 2:
       printf( "%5s %04hu-%02hu-%02hu_%02hu:%02hu:%02hu %04hu-%02hu-%02hu_%02hu:%02hu:%02hu %04hu-%02hu-%02hu_%02hu:%02hu:%02hu %10li %10li %s%s%s%s\n", fmtAttr(file->attrFile),
               cre->year+1980, cre->month, cre->day, tcre->hours, tcre->minutes, tcre->twosecs*2,
               wri->year+1980, wri->month, wri->day, twri->hours, twri->minutes, twri->twosecs*2,
               acc->year+1980, acc->month, acc->day, tacc->hours, tacc->minutes, tacc->twosecs*2,
               file->cbFileAlloc, file->cbFile, prnpathpfx, asdir?"[":"", filename, asdir?"]":"" ); break;
    }
    if(issubdir&&recursive) { 
      dotmask =  mask[0]=='.' && ( (mask[1]=='.'&&!mask[2]) || !mask[1] );
      olddirlen = pathpfxlen;
      ret = DosSetCurrentDir( (PSZ)filename ); if(ret) qerror_chdir(ret, (PSZ) file->achName);
      //printf("##%s\n",file->achName);
      if( !dotmask || mask[1] ) {
        realloc_pathpfx(pathpfxlen+namelen+1);
        memcpy(pathpfx+pathpfxlen, filename, namelen); pathpfxlen+=namelen; 
        pathpfx[pathpfxlen++]=PathSep; pathpfx[pathpfxlen]='\000'; 
      }

      findfiles( "*", attr | MUST_HAVE_DIRECTORY );
      findfiles( "*", attr & ! FILE_DIRECTORY );

      if(!dotmask) { ret = DosSetCurrentDir( (PSZ) ".." ); if(ret) qerror_chdir(ret,(PSZ)".."); }
      pathpfxlen = olddirlen; pathpfx[pathpfxlen] = '\000';
    }
    file=(FILEFINDBUF3*) ( (PCHAR)file + file->oNextEntryOffset );
  }
}

int filecount = 0;
PUCHAR pwd( ULONG letter, char* add, ULONG addlen, ULONG *wdlength, ULONG excess );

void findfiles(char *mask,ULONG attrs) {
  FILEFINDBUF3 filesfound[MaxFiles];
  ULONG nfiles; APIRET rc; HDIR hdir;
  hdir=HDIR_CREATE; nfiles=MaxFiles;    // HDIR_SYSTEM ... no second lsdir ever in progress
  rc = DosFindFirst((PCSZ)mask,&hdir,attrs,filesfound,sizeof(filesfound),&nfiles,FIL_STANDARD);
  if( mask[0]=='.' && ((mask[1]=='.' && !mask[2]) || !mask[1]) && (rc==ERROR_NO_MORE_FILES || rc==ERROR_PATH_NOT_FOUND ) ) {
    int len; APIRET ret;
    memset(filesfound,0,sizeof(FILEFINDBUF3)); filesfound[0].attrFile = FILE_DIRECTORY;
    filesfound[0].cchName=len=strlen(mask); memcpy(&(filesfound[0].cchName),mask,len);
    processfiles(filesfound,1,mask);
    ret = DosSetCurrentDir( (PSZ)mask ); if(ret) qerror_chdir(ret, (PSZ) mask);
    realloc_pathpfx(pathpfxlen+len+1);
    memcpy(pathpfx+pathpfxlen, mask, len); pathpfxlen+=len; 
    pathpfx[pathpfxlen++]=PathSep; pathpfx[pathpfxlen]='\000'; 
    DosFindClose(hdir); hdir=HDIR_CREATE; nfiles=MaxFiles; mask="*";
    rc = DosFindFirst((PCSZ)mask,&hdir,attrs,filesfound,sizeof(filesfound),&nfiles,FIL_STANDARD);
    printf("--%s\n",mask);
  }
  if(!rc) { processfiles(filesfound,nfiles,mask); filecount+=nfiles; }
  while( !rc ) { nfiles=MaxFiles;
    rc =  DosFindNext( hdir, filesfound, sizeof(filesfound), &nfiles );
    if(!rc) { processfiles(filesfound,nfiles,mask); filecount+=nfiles; }
  }
  if(rc!=ERROR_NO_MORE_FILES) { printerrorcode(rc); filecount=-1; printf("--%s\n",mask); }
  DosFindClose(hdir);
  //printf("{{%s,%s}}",pwd(0,NULL,0,NULL,0),mask);
}

PUCHAR pwd( ULONG letter, char* add, ULONG addlen, ULONG *wdlength, ULONG excess ) {
  APIRET ret; ULONG length=0; PSZ buf;
  ret = DosQueryCurrentDir( letter, NULL, &length );
  if(ret!=ERROR_BUFFER_OVERFLOW) { fprintf(stderr,"DosQueryCurrentDir failed to return buffer length with error code #%li.\n",ret); DosExit(EXIT_PROCESS,2); }
  buf = malloc(length+addlen+1+excess+3); buf[0]='A'-1+letter; buf[1]=':'; buf[2]='\\';
  ret = DosQueryCurrentDir( letter, buf+3, &length );
  if(ret) { fprintf(stderr,"DosQueryCurrentDir failed with error code #%li.\n",ret); DosExit(EXIT_PROCESS,3); }
  if( addlen > 0 ) {
    buf[length+2] = PathSep;
    memcpy( buf+length+3, add, addlen+1 );
    length += addlen + 1;
  }
  if(wdlength) *wdlength = length +2;   // \000 at the end is included in length
  return buf;
}

BOOL listcontent=TRUE;

char* PrepareTarget(ULONG *drivep, UCHAR **pathp, char **maskp, char *tg,BOOL *onHeap) {
  ULONG len; BOOL hasExcess=FALSE; BOOL isadir=FALSE; char *newtg,*cp,*dp; ULONG pfxlen,masklen; 
  BOOL skipbl=TRUE; BOOL hasdrivespec=FALSE; len = strlen(tg); 
  isadir= len>0 && ( tg[len-1]=='\\' || tg[len-1]=='/' );
  cp = strpbrk( tg, ":\\/");
  if( cp && *cp==':' ) { int pos; char letter;
    pos = cp - tg; letter = toupper(*tg);
    if( letter<'A' || letter>'Z' || pos!=1 ) { fprintf(stderr,"wrong drive spec in %s.",tg); DosExit(EXIT_PROCESS,1); } 
    if( ( len>2 && tg[2]!='\\' && tg[2]!='/' ) || (len==2) ) {
      tg = (char*)pwd( letter-'A'+1, tg+2, len-2, &len, 2 ); *onHeap=hasExcess=TRUE; isadir=TRUE;
    }
    hasdrivespec=TRUE;
  }
  if( len>0 && tg[len-1]==':' ) {
    BOOL isdrive=TRUE, err=FALSE; char letter;
    if(len!=2) { err=TRUE; isdrive = strchr(tg,'/')==NULL && strchr(tg,'\\')==NULL; }
    else { letter=toupper(*tg); err= letter<'A' || letter>'Z'; }
    if(err) { fprintf(stderr, isdrive ? "wrong drive spec: '%s'\n" : "wrong filename spec (':' used)\n", tg); DosExit(EXIT_PROCESS,1); } 
  }
  if( !isadir ) {
    FILESTATUS3 nodeinfo; APIRET ret;
    ret = DosQueryPathInfo( (PSZ)tg, FIL_STANDARD, &nodeinfo, sizeof(nodeinfo) );    
    if( ret && ret!=ERROR_INVALID_PATH && ret!=ERROR_PATH_NOT_FOUND && ret!=ERROR_FILE_NOT_FOUND) { 
      fprintf(stderr,"warning: DosQueryPathInfo/FIL_STANDARD returned %li for %s\n", ret, tg); }
    isadir = !ret && nodeinfo.attrFile & FILE_DIRECTORY;
  }
  if( isadir && listcontent && len>0 ) {
    // add path\* at the end; set mask to * and pfxlen to path 
    if(!hasExcess) { newtg=malloc(len+2); strncpy(newtg,tg,len+1); tg=newtg; *onHeap=hasExcess=TRUE; }
    if( tg[len-1]!='\\' && tg[len-1]!='/' ) tg[len++]='\\';
    if( len>=2 && tg[len-2]==':' ) pfxlen = len;   // d:\* -> pathpfx="d:\" and mask="*
    else pfxlen = len-1; // do not include trailing \; SetDir would not like that; however reserve space for it and term. \000.
    *maskp = tg+len; masklen=1;
    tg[len++]='*'; tg[len]='\000';
  } else if( printpraefix || recursive ) {
    // split: "pathpfx\mask" -> pfxlen="pathpfx" and mask="mask",  "\mask" -> pathpfx="\" and mask="",  "*" -> "","*"
    if( len>0 && ( tg[len-1]=='\\' || tg[len-1]=='/' ) ) cp=tg+len-2; // ignore trailing \; strip it later on from mask
    else cp=tg+len-1;
    for(; cp>=tg; cp-- ) if( *cp=='\\' || *cp=='/' ) break;
    pfxlen = cp + 1 - tg; if(pfxlen>1) pfxlen--; else if(pfxlen==1) skipbl=FALSE; // keep "", "."; strip "\" for "pathpfx\mask"
    else if(hasdrivespec) { pfxlen=3; } // pfxlen==0
    //printf("((%li,%lu))",skipbl,pfxlen);
    *maskp = tg + pfxlen + (skipbl?1:0);  masklen = len - pfxlen - (skipbl?1:0);
    if(**maskp=='\000') { *maskp=listcontent ? "*" : "."; masklen=1; }
    if( cp>tg && *(cp-1)==':' && pfxlen<len ) pfxlen++; // d:\temp -> pathpfx="d:\" and mask="temp"
  }
  //printf("<<tg=%s,pfxlen=%li,mask=%s,masklen=%lu>>\n",tg,pfxlen,*maskp,masklen);
  if( printpraefix || recursive ) { 
    // copy pfxlen bytes into pathpfx/pathpfxlen - buffer  (convert '/'~ '\')
    realloc_pathpfx( pfxlen+1 ); pathpfxlen=pfxlen;
    for( cp=tg, dp=(char*)pathpfx; pfxlen; pfxlen--, cp++, dp++ ) if( *cp=='/' || *cp=='\\' ) *dp = PathSep; else *dp=*cp;
    *dp = '\000'; 
    //printf("<<pathpfx=%s,pathpfxlen=%li>>\n",pathpfx,pathpfxlen);
    // peel drive letter in front if necessary; make everything after pathpfx(+1) the mask, set mask to "*" if empty
    if( pathpfxlen>1 && pathpfx[1]==':' ) { *pathp = pathpfx+2; *drivep=toupper(pathpfx[0])-'A'+1; }
    else { *pathp = pathpfx; *drivep=0; }
    // if(pathpfxlen>0) { *mask = tg + pathpfxlen + 1; masklen = len - (pathpfxlen+1); } //note: if pathpfx is nonempty followed by "\" in tg
    // else { *mask = tg; masklen = len; }
    if(**pathp=='\000') *pathp=NULL; // { if(*drivep==0) *pathp=NULL; else *pathp=(PSZ)"\\"; } // also possible: path=".", pathpfx-buf already contains ""
  } else {
    *pathp = NULL; 
    if( len>1 && tg[1]==':' ) { *maskp=tg+2; masklen=len-2; *drivep=toupper(tg[0])-'A'+1; }
    else { *maskp = tg; masklen = len; *drivep = 0; }
  }
  //printf("&<%s,%li>\n",*maskp,masklen);
  { char *mask = *maskp;
    if( masklen>0 && ( mask[masklen-1]=='\\' || mask[masklen-1]=='/' ) ) {
      // strip possible trailing "\" from mask
      masklen--;
      if(hasExcess) mask[masklen]='\000';
      else { newtg=malloc(masklen+1); memcpy(newtg,mask,masklen); newtg[masklen]='\000'; *maskp=mask=newtg;  }
      //printf("&<%s,%li>\n",*maskp,masklen);
    }
    // mask is "." or ".." (-> cp<mask )?
    for( cp=mask+masklen-1; cp>=mask; cp--) if(*cp!='.') break;
    //printf("qqq%sqq%sq\n",mask,cp);
    if( FALSE && cp<mask && recursive && !flatten ) { 
      // #1 pathp needs to stay the same for chdir
      if(*pathp!=NULL) { *pathp = malloc( pathpfxlen+1 ); memcpy(*pathp,pathpfx,pathpfxlen+1); }
      // #2 add mask to printable path and add an additional .. because even . stays in ..
      realloc_pathpfx( pathpfxlen + masklen + 5 );
      if(pathpfxlen>0) pathpfx[pathpfxlen++] = PathSep;
      memcpy( (char*) pathpfx + pathpfxlen, mask, masklen+1 ); pathpfxlen += masklen;
      pathpfx[pathpfxlen++] = PathSep;
      pathpfx[pathpfxlen++] = '.'; pathpfx[pathpfxlen++] = '.';
    }
  }
  prnpathlen = pathpfxlen;
  if( printpraefix ) prnpathpfx = (char*)pathpfx; else { prnpathpfx = ""; prnpathlen=0; }
  if( flatten && printpraefix ) { // flatten leading ../ out
    char *path = prnpathpfx;
    if( *path=='.' ) do { path++; } while( *path=='.' || *path==PathSep ); 
    prnpathlen -= path - prnpathpfx;
    prnpathpfx = (char*)path; 
    // pathp itself stays the same so that chdir will not be affected; only printing of paths will be stripped from leading ..\...
  }
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
      case 'l': longformat++; break;          case '1': longformat=-2; break;           case 's': longformat--; break;
      case 'd': listcontent=FALSE; break;    case 'p': plainnames=TRUE; break;
      case 'r': recursive=TRUE; break;
      case 'u': PathSep='/'; break;             case 'c': bracketdir=FALSE; break;
      case 'x': recursive=TRUE; PathSep='/'; bracketdir=FALSE; longformat=-1; break;
      case 'f': flatten=TRUE; break;
      default: fprintf(stderr,"%sunknown option -%c.%s\n",ev,*opts,nv);
    }; opts++;
  }
}

int main(int argc, char *argv[]) {
  ULONG drive; PSZ path; char *mask; PSZ cwd=NULL; ULONG cd=0; APIRET ret; ULONG drivemap;
  argc--; progname=*argv; argv++;
  min_access.fields = min_creation.fields = min_write.fields = 0;
  max_access.fields = max_creation.fields = max_write.fields = 0;
  min_access.cond = min_creation.cond = min_write.cond = TRUE;
  max_access.cond = max_creation.cond = max_write.cond = !TRUE;

  while(argc&&argv[0][0]=='-') { 
    if(!strcmp(*argv,"-h")|!strcmp(*argv,"--help")) { help(); return 0; } else
    if( (*argv)[0]=='-' && (*argv)[1]!='\000' && (*argv)[1]!='-') processShortOpts(*argv+1); else
    if(!strncmp(*argv,"--access-time>=",15)) parse_time(&min_access, *argv+15, 0 ); else
    if(!strncmp(*argv,"--creation-time>=",17)) parse_time(&min_creation, *argv+17, 0 ); else
    if(!strncmp(*argv,"--write-time>=",14)) parse_time(&min_write, *argv+14, 0 ); else
    if(!strncmp(*argv,"--access-time>",14)) parse_time(&min_access, *argv+14, 1 ); else
    if(!strncmp(*argv,"--creation-time>",16)) parse_time(&min_creation, *argv+16, 1 ); else
    if(!strncmp(*argv,"--write-time>",13)) parse_time(&min_write, *argv+13, 1 ); else

    if(!strncmp(*argv,"--access-time<=",15)) parse_time(&max_access, *argv+15, !0 ); else
    if(!strncmp(*argv,"--creation-time<=",17)) parse_time(&max_creation, *argv+17, !0 ); else
    if(!strncmp(*argv,"--write-time<=",14)) parse_time(&max_write, *argv+14, !0 ); else
    if(!strncmp(*argv,"--access-time<",14)) parse_time(&max_access, *argv+14, !1 ); else
    if(!strncmp(*argv,"--creation-time<",16)) parse_time(&max_creation, *argv+16, !1 ); else
    if(!strncmp(*argv,"--write-time<",13)) parse_time(&max_write, *argv+13, !1 ); else

    if(!strncmp(*argv,"--access-time=",14)) { parse_time(&min_access, *argv+14, 0 ); max_access=min_access; max_access.cond=!1; } else
    if(!strncmp(*argv,"--creation-time=",16)) { parse_time(&min_creation, *argv+16, 0 ); max_creation=min_creation; max_creation.cond=!1; } else
    if(!strncmp(*argv,"--write-time=",13)) { parse_time(&min_write, *argv+13, 0 ); max_write=min_write; max_write.cond=!1; } else

    fprintf(stderr,"%sunknown option %s!%s\n",ev,*argv,nv);
    argc--; argv++; 
  }
  printpraefix = recursive ^ plainnames;
  do {
    if(argc--) DirMeWhat=argv++[0];     ret=0;
    DirMeWhat = PrepareTarget( &drive, &path, &mask, DirMeWhat, &onHeapDMW );
    if( path || drive ) {
      if(!cwd) { DosQueryCurrentDisk( &cd, &drivemap ); cwd = pwd(cd,"",0,NULL,0); }
      if(drive!=0) { ret = DosSetDefaultDisk( drive );
                      if( ret==ERROR_INVALID_DRIVE ) { fprintf(stderr,"invalid drive: %c #%i\n",(char)drive+'A'-1,(int)drive); if(argc>0) continue; else break; } }
      if(!ret&&path) { ret = DosSetCurrentDir( path );
                 if( ret==ERROR_PATH_NOT_FOUND ) { fprintf(stderr,"path not found: '%s'\n",path); if(argc>0) continue; else { DosSetDefaultDisk(cd); break; } } }
      // now add the stripped trailing \ again to make it seeable in the output
    }
    //if( pathpfxlen>0 && pathpfx[pathpfxlen-1]!='\\' ) { pathpfx[pathpfxlen++]=PathSep; pathpfx[pathpfxlen]='\000'; }
    if( prnpathlen>0 && pathpfx[pathpfxlen-1]!=PathSep ) { pathpfx[pathpfxlen++]=PathSep; pathpfx[pathpfxlen]='\000'; }
    //printf("<<%s#%s>>\n",path,mask);
    if(!ret) {
      printheading();                                                                             
      findfiles( mask, attr | MUST_HAVE_DIRECTORY );        // recommendation: not to use the MUST_HAVE flags
      findfiles( mask, dirattr & ! FILE_DIRECTORY );
      if( path ) { ret = DosSetDefaultDisk( cd ); if(ret) qerror_defdisk(ret,cd); }
      if( drive ) {  ret = DosSetCurrentDir( cwd ); if(ret) qerror_chdir(ret,cwd);  }
    }
    if(onHeapDMW) free(DirMeWhat);
  } while (argc>0);
  return 0;
}


