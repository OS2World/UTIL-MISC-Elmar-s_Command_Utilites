#define INCL_DOSFILEMGR
#define INCL_DOSERRORS
#include <os2.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <locale.h>
#include <ctype.h>

char *progname;

void help() {
  char *npn = strrchr(progname,'\\');
  printf("%s -lrab drvbst\r\n", npn?npn+1:progname );
  printf("  -l ... local\r\n"
         "  -r ... remote\r\n"
         "  -a ... all\r\n"
         "  -b ... include a: and b:\r\n"
         "  drvbst ... f.i. cde for c: d: e:\r\n"
         "note: -a will also list drives not ready; -l and -r not.\r\n"
         "       drives will appear sorted; for -lr or -rl local drives first.\r\n");
  DosExit(EXIT_PROCESS,0);
}

#define drvBst(drvno) ( (drvno-1)<='Z'-'A' ? 'A'+(CHAR)(drvno-1) : '?' )
ULONG DriveMap, CurDriveNo;
CHAR PathSep = '\\';

UCHAR origpathbuf[CCHMAXPATH]; UCHAR *path = origpathbuf; ULONG pathmaxlen = sizeof(origpathbuf);

APIRET drvPath(UCHAR **pathbuf, ULONG *pathbuflen, ULONG drvno) {
  ULONG pathactlen; PUCHAR pchar; APIRET rc; 
  pathactlen = *pathbuflen;
  rc = DosQueryCurrentDir( drvno, *pathbuf, &pathactlen );
  if(rc==ERROR_BUFFER_OVERFLOW) {
    pathactlen *= 2; if( *pathbuf != origpathbuf ) free(*pathbuf);
    *pathbuf = malloc( pathactlen );
    rc = DosQueryCurrentDir( drvno, *pathbuf, &pathactlen );
  }
  if(rc==0) { 
    if(PathSep!='\\') for(pchar=*pathbuf; *pchar; pchar++) if(*pchar=='\\') *pchar=PathSep;
  } else switch(rc) {
    case ERROR_NOT_READY: strncpy((char*)*pathbuf,"drive is not ready (no media?)",*pathbuflen); (*pathbuf)[*pathbuflen-1]='\000'; break;
    case ERROR_INVALID_DRIVE: strncpy((char*)*pathbuf,"invalid drive",*pathbuflen); (*pathbuf)[*pathbuflen-1]='\000'; break;
    case ERROR_NOT_DOS_DISK: strncpy((char*)*pathbuf,"unknown media or filesystem type",*pathbuflen); (*pathbuf)[*pathbuflen-1]='\000'; break;
    case ERROR_DRIVE_LOCKED: strncpy((char*)*pathbuf,"drive locked by other process",*pathbuflen); (*pathbuf)[*pathbuflen-1]='\000'; break;
    default: snprintf((char*)*pathbuf,*pathbuflen,"error: type helpmsg %li.",rc);  // write at most n-1 chars; n-th char -> '\000'
//    default: strncpy((char*)*pathbuf,"an unknown error occured.",*pathbuflen); (*pathbuf)[*pathbuflen-1]='\000'; break;
  }
  return rc;
}


BOOL drvReady(ULONG devno) {
   return TRUE;
}

typedef BOOL (*TDrvSel) (ULONG drvno,BYTE param);

BOOL showlocal(ULONG drvno,BYTE remote) {
  UCHAR devname[3]; BYTE fsqBuffer[sizeof(FSQBUFFER2)+(3*CCHMAXPATH)]; APIRET rc;
  PFSQBUFFER2 fsinfo = (PFSQBUFFER2) fsqBuffer; ULONG fsinfolen= sizeof(fsqBuffer);
  if(!drvReady(drvno)) return FALSE;
  devname[0] = drvBst(drvno); devname[1] = ':'; devname[2] = '\000';
  rc = DosQueryFSAttach( devname, 0, FSAIL_QUERYNAME, fsinfo, &fsinfolen );
  if(rc!=0&&rc!=ERROR_NOT_READY) fprintf(stderr,"error: type helpmsg %li\r\n",rc);
  return (rc!=ERROR_NOT_READY) && ( rc!=0 || (( fsinfo->iType == FSAT_LOCALDRV ) ^ remote) );  // rc! =0: im Fehlerfall doch anzeigen auáer bei notready
}

BOOL showall(ULONG drvno,BYTE nulparam) { return TRUE; }

void allDrivePaths(TDrvSel showit,BYTE param) {
  ULONG drvno, drvbit; APIRET rc;
  for(drvno=1, drvbit=1; drvbit; drvno++, drvbit<<=1) if ( DriveMap & drvbit && showit(drvno,param) ) {
    rc = drvPath(&path,&pathmaxlen, drvno );
    printf("%c:%c%s\r\n", drvBst(drvno), rc ? ' ' : PathSep, path );
  }
}

#define PRMS 6
char *param[PRMS] = { "local", "remote", "all", "b", "unix", "help" };
BYTE prmval[PRMS] = { FALSE };

int main(int argc, char *argv[]) { APIRET rc; int i,j; char *pc;
  ULONG ViewMap; BOOL noparam; char c;
  progname = *argv; argv++; argc--;
  rc =DosQueryCurrentDisk( &CurDriveNo, &DriveMap ); if(rc) { fprintf(stderr,"error %lu on DosQueryCurrentDisk\r\n",rc); return rc; }

  while( argc && argv[0][0]=='-' ) {
    if(argv[0][1]=='-') {
      for( i=0; i<PRMS; i++ ) if( !strcasecmp( param[i], argv[0]+2 ) ) { prmval[i]=TRUE; i=PRMS+3; break; }
      if( i<PRMS+3 ) fprintf(stderr,"unknown option %s\r\n",argv[0]);
    } else {
      for( pc=argv[0]+1; *pc; pc++ ) {
        for( i=0; i<PRMS; i++ ) if( param[i][0] == *pc ) { prmval[i]=TRUE; i=PRMS+3; break; }
        if( i<PRMS+3 ) fprintf(stderr,"unknown option -%c\r\n",*pc);
    }}
    argc--; argv++;
  }
  //for( i=0; i<PRMS; i++ ) { printf("%i=%i, ", i, prmval[i] ); }
  if(prmval[5]) help();         if(prmval[4]) PathSep='/';
  noparam = !( prmval[0] || prmval[1] || prmval[2] );  // neither local, remote or all specified

  if( argc > 0 ) { ViewMap=0;  // show only
    while( argc > 0 ) { 
      for( pc=argv[0]; *pc; pc++ ) { c=toupper(*pc); 
        if( c>='A' && c<='Z' ) ViewMap |= 1 << (c-'A'); else fprintf(stderr,"invalid drive specifier: %c:\r\n",*pc);
      }
      argc--; argv++;
    }
    if(prmval[3]) ViewMap |= 3;   DriveMap &= ViewMap;
    if( noparam ) { prmval[2]=TRUE; noparam=FALSE; }   // show all stated drives
  } else {
    if( !prmval[3] ) DriveMap &= ~3;   // do not show a,b unless explicitly stated via -b
  }

  if(noparam) {
    rc = drvPath(&path,&pathmaxlen, CurDriveNo );
    printf("%c:%c%s\r\n", drvBst(CurDriveNo), rc ? ' ' : PathSep, path );
  }
  else if( prmval[2] ) allDrivePaths(showall,0);
  else {
    if( prmval[0] ) allDrivePaths(showlocal,0);
    if( prmval[1] ) allDrivePaths(showlocal,1);
  }

  return 0;
}








