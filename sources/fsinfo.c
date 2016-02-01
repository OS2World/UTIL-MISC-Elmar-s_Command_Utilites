#define INCL_DOSFILEMGR
#define INCL_DOSERRORS
#include <os2.h>
#include <stdio.h>
#include <string.h>

#define drvBst(drvno) ( (drvno-1)<='Z'-'A' ? 'A'+(CHAR)(drvno-1) : '?' )
ULONG DriveMap, CurDriveNo;
CHAR PathSep = '\\';

UCHAR pathbuf[260]; UCHAR *path = pathbuf; ULONG pathmaxlen = sizeof(pathbuf);

APIRET drvPath(UCHAR **pathbuf, ULONG *pathbuflen, ULONG drvno) {
  ULONG pathactlen; PUCHAR pchar; APIRET rc; 
  pathactlen = *pathbuflen;
  rc = DosQueryCurrentDir( drvno, *pathbuf, &pathactlen );
  if(rc==0) { 
    if(PathSep!='\\') for(pchar=*pathbuf; *pchar; pchar++) if(*pchar=='\\') *pchar=PathSep;
  } else switch(rc) {
    case ERROR_NOT_READY: strncpy((char*)*pathbuf,"drive is not ready (no media?)",*pathbuflen); (*pathbuf)[*pathbuflen-1]='\000'; break;
    case ERROR_INVALID_DRIVE: strncpy((char*)*pathbuf,"invalid drive",*pathbuflen); (*pathbuf)[*pathbuflen-1]='\000'; break;
    case ERROR_NOT_DOS_DISK: strncpy((char*)*pathbuf,"unknown media or filesystem type",*pathbuflen); (*pathbuf)[*pathbuflen-1]='\000'; break;
    case ERROR_DRIVE_LOCKED: strncpy((char*)*pathbuf,"drive locked by other process",*pathbuflen); (*pathbuf)[*pathbuflen-1]='\000'; break;
    default: snprintf((char*)*pathbuf,*pathbuflen,"error: type helpmsg %li.",rc);
//    default: strncpy((char*)*pathbuf,"an unknown error occured.",*pathbuflen); (*pathbuf)[*pathbuflen-1]='\000'; break;
  }
  return rc;
}

typedef BOOL (*TDrvSel) (ULONG drvno);

BOOL showlocal2(ULONG drvno) {
  UCHAR devname[3]; BYTE fsqBuffer[sizeof(FSQBUFFER2)+(3*CCHMAXPATH)]; APIRET rc;
  PFSQBUFFER2 fsinfo = (PFSQBUFFER2) fsqBuffer; ULONG fsinfolen= sizeof(fsqBuffer);
  devname[0] = drvBst(drvno); devname[1] = ':'; devname[2] = '\000';
  rc = DosQueryFSAttach( devname, 0, FSAIL_QUERYNAME, fsinfo, &fsinfolen );
  if(rc!=0&&rc!=ERROR_NOT_READY) fprintf(stderr,"error: type helpmsg %li\n",rc);
  return (rc!=ERROR_NOT_READY) && ( rc!=0 || fsinfo->iType == FSAT_LOCALDRV );
}

BOOL showall(ULONG drvno) { return TRUE; }

void allDrivePaths(TDrvSel showit) {
  ULONG drvno, drvbit; APIRET rc;
  for(drvno=1, drvbit=1; drvbit; drvno++, drvbit<<=1) if ( DriveMap & drvbit && showit(drvno) ) {
    rc = drvPath(&path,&pathmaxlen, drvno );
    printf("%c:%c%s\n", drvBst(drvno), rc ? ' ' : PathSep, path );
  }
}

int main(int argc, char *argv[]) { APIRET rc;
  rc =DosQueryCurrentDisk( &CurDriveNo, &DriveMap ); if(rc) { fprintf(stderr,"error %lu on DosQueryCurrentDisk\n",rc); return rc; }

  rc = drvPath(&path,&pathmaxlen, CurDriveNo );
  printf("%c:%c%s\n", drvBst(CurDriveNo), rc ? ' ' : PathSep, path );

  allDrivePaths(showlocal);

  return 0;
}
