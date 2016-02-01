# 1 "indirect5.c"
# 1 "<eingebaut>"
# 1 "<Kommandozeile>"
# 1 "indirect5.c"



# 1 "/@unixroot/usr/include/os2.h" 1 3 4
# 35 "/@unixroot/usr/include/os2.h" 3 4
# 1 "/@unixroot/usr/include/os2emx.h" 1 3 4
# 9 "/@unixroot/usr/include/os2emx.h" 3 4
#pragma pack(1)
# 204 "/@unixroot/usr/include/os2emx.h" 3 4
typedef int INT;
typedef unsigned UINT;
typedef unsigned long APIRET;

typedef unsigned long BOOL;
typedef BOOL *PBOOL;

typedef unsigned long BOOL32;
typedef BOOL *PBOOL32;

typedef char CHAR;
typedef CHAR *PCHAR;



typedef unsigned char BYTE;
typedef unsigned char *PCH;
typedef unsigned char *PSZ;
typedef __const__ unsigned char *PCCH;
typedef __const__ unsigned char *PCSZ;
# 235 "/@unixroot/usr/include/os2emx.h" 3 4
typedef BYTE *PBYTE;

typedef unsigned char UCHAR;
typedef UCHAR *PUCHAR;

typedef short SHORT;
typedef SHORT *PSHORT;

typedef unsigned short USHORT;
typedef USHORT *PUSHORT;

typedef long LONG;
typedef LONG *PLONG;

typedef unsigned long ULONG;
typedef ULONG *PULONG;



typedef long long LONGLONG;
typedef LONGLONG *PLONGLONG;

typedef unsigned long long ULONGLONG;
typedef ULONGLONG *PULONGLONG;
# 278 "/@unixroot/usr/include/os2emx.h" 3 4
typedef void *PVOID;
typedef PVOID *PPVOID;

typedef __const__ void *CPVOID;

typedef CHAR STR8[8];
typedef STR8 *PSTR8;

typedef CHAR STR16[16];
typedef STR16 *PSTR16;
typedef CHAR STR32[32];
typedef STR32 *PSTR32;
typedef CHAR STR64[64];
typedef STR64 *PSTR64;

typedef unsigned short SHANDLE;
typedef unsigned long LHANDLE;

typedef LHANDLE HPIPE;
typedef HPIPE *PHPIPE;

typedef LHANDLE HQUEUE;
typedef HQUEUE *PHQUEUE;

typedef LHANDLE HMODULE;
typedef HMODULE *PHMODULE;

typedef void *HSEM;
typedef HSEM *PHSEM;

typedef LHANDLE HOBJECT;

typedef ULONG PID;
typedef PID *PPID;

typedef ULONG TID;
typedef TID *PTID;




typedef int __attribute__((__system__)) _PFN();

typedef _PFN *PFN;
typedef PFN *PPFN;

typedef USHORT SEL;
typedef SEL *PSEL;

typedef ULONG HMTX;
typedef HMTX *PHMTX;

typedef ULONG HMUX;
typedef HMUX *PHMUX;
# 1133 "/@unixroot/usr/include/os2emx.h" 3 4
typedef struct _PANOSE
{
  BYTE bFamilyType;
  BYTE bSerifStyle;
  BYTE bWeight;
  BYTE bProportion;
  BYTE bContrast;
  BYTE bStrokeVariation;
  BYTE bArmStyle;
  BYTE bLetterform;
  BYTE bMidline;
  BYTE bXHeight;
  BYTE fbPassedISO;
  BYTE fbFailedISO;
} PANOSE;

typedef struct _FONTMETRICS
{
  CHAR szFamilyname[32];
  CHAR szFacename[32];
  USHORT idRegistry;
  USHORT usCodePage;
  LONG lEmHeight;
  LONG lXHeight;
  LONG lMaxAscender;
  LONG lMaxDescender;
  LONG lLowerCaseAscent;
  LONG lLowerCaseDescent;
  LONG lInternalLeading;
  LONG lExternalLeading;
  LONG lAveCharWidth;
  LONG lMaxCharInc;
  LONG lEmInc;
  LONG lMaxBaselineExt;
  SHORT sCharSlope;
  SHORT sInlineDir;
  SHORT sCharRot;
  USHORT usWeightClass;
  USHORT usWidthClass;
  SHORT sXDeviceRes;
  SHORT sYDeviceRes;
  SHORT sFirstChar;
  SHORT sLastChar;
  SHORT sDefaultChar;
  SHORT sBreakChar;
  SHORT sNominalPointSize;
  SHORT sMinimumPointSize;
  SHORT sMaximumPointSize;
  USHORT fsType;
  USHORT fsDefn;
  USHORT fsSelection;
  USHORT fsCapabilities;
  LONG lSubscriptXSize;
  LONG lSubscriptYSize;
  LONG lSubscriptXOffset;
  LONG lSubscriptYOffset;
  LONG lSuperscriptXSize;
  LONG lSuperscriptYSize;
  LONG lSuperscriptXOffset;
  LONG lSuperscriptYOffset;
  LONG lUnderscoreSize;
  LONG lUnderscorePosition;
  LONG lStrikeoutSize;
  LONG lStrikeoutPosition;
  SHORT sKerningPairs;
  SHORT sFamilyClass;
  LONG lMatch;
  LONG FamilyNameAtom;
  LONG FaceNameAtom;
  PANOSE panose;
} FONTMETRICS;
typedef FONTMETRICS *PFONTMETRICS;

typedef struct _FATTRS
{
  USHORT usRecordLength;
  USHORT fsSelection;
  LONG lMatch;
  CHAR szFacename[32];
  USHORT idRegistry;
  USHORT usCodePage;
  LONG lMaxBaselineExt;
  LONG lAveCharWidth;
  USHORT fsType;
  USHORT fsFontUse;
} FATTRS;
typedef FATTRS *PFATTRS;
# 1270 "/@unixroot/usr/include/os2emx.h" 3 4
ULONG __attribute__((__system__)) DosAliasMem (CPVOID pv, ULONG cb, PPVOID ppvAlias, ULONG fl);
ULONG __attribute__((__system__)) DosAllocMem (PPVOID pBaseAddress, ULONG ulObjectSize,
    ULONG ulAllocationFlags);
ULONG __attribute__((__system__)) DosAllocSharedMem (PPVOID pBaseAddress, PCSZ pszName,
    ULONG ulObjectSize, ULONG ulAllocationFlags);
ULONG __attribute__((__system__)) DosFreeMem (PVOID pBaseAddress);
ULONG __attribute__((__system__)) DosGetNamedSharedMem (PPVOID pBaseAddress, PCSZ pszSharedMemName,
    ULONG ulAttributeFlags);
ULONG __attribute__((__system__)) DosGetSharedMem (CPVOID pBaseAddress, ULONG ulAttributeFlags);
ULONG __attribute__((__system__)) DosGiveSharedMem (CPVOID pBaseAddress, PID idProcessId,
    ULONG ulAttributeFlags);
ULONG __attribute__((__system__)) DosQueryMem (CPVOID pBaseAddress, PULONG pulRegionSize,
    PULONG pulAllocationFlags);
ULONG __attribute__((__system__)) DosQueryMemState (CPVOID pv, PULONG cb, PULONG pfl);
ULONG __attribute__((__system__)) DosSetMem (CPVOID pBaseAddress, ULONG ulRegionSize,
    ULONG ulAttributeFlags);
ULONG __attribute__((__system__)) DosSubAllocMem (PVOID pOffset, PPVOID pBlockOffset, ULONG ulSize);
ULONG __attribute__((__system__)) DosSubFreeMem (PVOID pOffset, PVOID pBlockOffset, ULONG ulSize);
ULONG __attribute__((__system__)) DosSubSetMem (PVOID pOffset, ULONG ulFlags, ULONG ulSize);
ULONG __attribute__((__system__)) DosSubUnsetMem (PVOID pOffset);


USHORT __attribute__((__system__)) DosAllocSeg(USHORT cbSize, PSEL pSel, USHORT fsAlloc);
USHORT __attribute__((__system__)) DosFreeSeg(SEL sel);
USHORT __attribute__((__system__)) DosReallocSeg(USHORT cbNewSize, SEL sel);
# 1461 "/@unixroot/usr/include/os2emx.h" 3 4
typedef LHANDLE HFILE;
typedef HFILE *PHFILE;

typedef ULONG FHLOCK;
typedef PULONG PFHLOCK;

typedef LHANDLE HDIR;
typedef HDIR *PHDIR;
# 1479 "/@unixroot/usr/include/os2emx.h" 3 4
typedef struct _FTIME
{
  unsigned twosecs : 5;
  unsigned minutes : 6;
  unsigned hours : 5;
} FTIME;

typedef FTIME *PFTIME;
# 1496 "/@unixroot/usr/include/os2emx.h" 3 4
typedef struct _FDATE
{
  unsigned day : 5;
  unsigned month : 4;
  unsigned year : 7;
} FDATE;

typedef FDATE *PFDATE;

typedef struct _FEA
{
  BYTE fEA;
  BYTE cbName;
  USHORT cbValue;
} FEA;
typedef FEA *PFEA;

typedef struct _FEALIST
{
  ULONG cbList;
  FEA list[1];
} FEALIST;
typedef FEALIST *PFEALIST;

typedef struct _GEA
{
  BYTE cbName;
  CHAR szName[1];
} GEA;
typedef GEA *PGEA;

typedef struct _GEALIST
{
  ULONG cbList;
  GEA list[1];
} GEALIST;
typedef GEALIST *PGEALIST;

typedef struct _EAOP
{
  PGEALIST fpGEAList;
  PFEALIST fpFEAList;
  ULONG oError;
} EAOP;
typedef EAOP *PEAOP;

typedef struct _FEA2
{
  ULONG oNextEntryOffset;
  BYTE fEA;
  BYTE cbName;
  USHORT cbValue;
  CHAR szName[1];
} FEA2;
typedef FEA2 *PFEA2;

typedef struct _FEA2LIST
{
  ULONG cbList;
  FEA2 list[1];
} FEA2LIST;
typedef FEA2LIST *PFEA2LIST;

typedef struct _GEA2
{
  ULONG oNextEntryOffset;
  BYTE cbName;
  CHAR szName[1];
} GEA2;
typedef GEA2 *PGEA2;

typedef struct _GEA2LIST
{
  ULONG cbList;
  GEA2 list[1];
} GEA2LIST;
typedef GEA2LIST *PGEA2LIST;

typedef struct _EAOP2
{
  PGEA2LIST fpGEA2List;
  PFEA2LIST fpFEA2List;
  ULONG oError;
} EAOP2;
typedef EAOP2 *PEAOP2;

typedef struct _DENA1
{
  UCHAR reserved;
  UCHAR cbName;
  USHORT cbValue;
  UCHAR szName[1];
} DENA1;
typedef DENA1 *PDENA1;

typedef FEA2 DENA2;
typedef PFEA2 PDENA2;

typedef struct _EASIZEBUF
{
  USHORT cbMaxEASize;
  ULONG cbMaxEAListSize;
} EASIZEBUF;
typedef EASIZEBUF *PEASIZEBUF;

typedef struct _ROUTENAMEBUF
{
  ULONG hRouteHandle;
  UCHAR szRouteName;
} ROUTENAMEBUF;
typedef ROUTENAMEBUF *PROUTENAMEBUF;

typedef struct _FSDTHREAD
{
  USHORT usFunc;
  USHORT usStackSize;
  ULONG ulPriorityClass;
  LONG lPriorityLevel;
} FSDTHREAD;

typedef struct _FSDDAEMON
{
  USHORT usNumThreads;
  USHORT usMoreFlag;
  USHORT usCallInstance;
  FSDTHREAD tdThrds[16];
} FSDDAEMON;

typedef struct _FILEFINDBUF
{
  FDATE fdateCreation;
  FTIME ftimeCreation;
  FDATE fdateLastAccess;
  FTIME ftimeLastAccess;
  FDATE fdateLastWrite;
  FTIME ftimeLastWrite;
  ULONG cbFile;
  ULONG cbFileAlloc;
  USHORT attrFile;
  UCHAR cchName;
  CHAR achName[256];
} FILEFINDBUF;
typedef FILEFINDBUF *PFILEFINDBUF;

typedef struct _FILEFINDBUF2
{
  FDATE fdateCreation;
  FTIME ftimeCreation;
  FDATE fdateLastAccess;
  FTIME ftimeLastAccess;
  FDATE fdateLastWrite;
  FTIME ftimeLastWrite;
  ULONG cbFile;
  ULONG cbFileAlloc;
  USHORT attrFile;
  ULONG cbList;
  UCHAR cchName;
  CHAR achName[256];
} FILEFINDBUF2;
typedef FILEFINDBUF2 *PFILEFINDBUF2;

typedef struct _FILEFINDBUF3
{
  ULONG oNextEntryOffset;
  FDATE fdateCreation;
  FTIME ftimeCreation;
  FDATE fdateLastAccess;
  FTIME ftimeLastAccess;
  FDATE fdateLastWrite;
  FTIME ftimeLastWrite;
  ULONG cbFile;
  ULONG cbFileAlloc;
  ULONG attrFile;
  UCHAR cchName;
  CHAR achName[256];
} FILEFINDBUF3;
typedef FILEFINDBUF3 *PFILEFINDBUF3;

typedef struct _FILEFINDBUF4
{
  ULONG oNextEntryOffset;
  FDATE fdateCreation;
  FTIME ftimeCreation;
  FDATE fdateLastAccess;
  FTIME ftimeLastAccess;
  FDATE fdateLastWrite;
  FTIME ftimeLastWrite;
  ULONG cbFile;
  ULONG cbFileAlloc;
  ULONG attrFile;
  ULONG cbList;
  UCHAR cchName;
  CHAR achName[256];
} FILEFINDBUF4;
typedef FILEFINDBUF4 *PFILEFINDBUF4;

typedef struct _FILEFINDBUF3L
{
    ULONG oNextEntryOffset;
    FDATE fdateCreation;
    FTIME ftimeCreation;
    FDATE fdateLastAccess;
    FTIME ftimeLastAccess;
    FDATE fdateLastWrite;
    FTIME ftimeLastWrite;
    LONGLONG cbFile;
    LONGLONG cbFileAlloc;
    ULONG attrFile;
    UCHAR cchName;
    CHAR achName[256];
} FILEFINDBUF3L;
typedef FILEFINDBUF3L *PFILEFINDBUF3L;

typedef struct _FILEFINDBUF4L
{
    ULONG oNextEntryOffset;
    FDATE fdateCreation;
    FTIME ftimeCreation;
    FDATE fdateLastAccess;
    FTIME ftimeLastAccess;
    FDATE fdateLastWrite;
    FTIME ftimeLastWrite;
    LONGLONG cbFile;
    LONGLONG cbFileAlloc;
    ULONG attrFile;
    ULONG cbList;
    UCHAR cchName;
    CHAR achName[256];
} FILEFINDBUF4L;
typedef FILEFINDBUF4L *PFILEFINDBUF4L;

typedef struct _FILELOCK
{
  LONG lOffset;
  LONG lRange;
} FILELOCK;
typedef FILELOCK *PFILELOCK;

typedef struct _FILELOCKL
{
  LONGLONG lOffset;
  LONGLONG lRange;
} FILELOCKL;
typedef FILELOCKL *PFILELOCKL;

typedef struct _FILESTATUS
{
  FDATE fdateCreation;
  FTIME ftimeCreation;
  FDATE fdateLastAccess;
  FTIME ftimeLastAccess;
  FDATE fdateLastWrite;
  FTIME ftimeLastWrite;
  ULONG cbFile;
  ULONG cbFileAlloc;
  USHORT attrFile;
} FILESTATUS;
typedef FILESTATUS *PFILESTATUS;

typedef struct _FILESTATUS2
{
  FDATE fdateCreation;
  FTIME ftimeCreation;
  FDATE fdateLastAccess;
  FTIME ftimeLastAccess;
  FDATE fdateLastWrite;
  FTIME ftimeLastWrite;
  ULONG cbFile;
  ULONG cbFileAlloc;
  USHORT attrFile;
  ULONG cbList;
} FILESTATUS2;
typedef FILESTATUS2 *PFILESTATUS2;

typedef struct _FILESTATUS3
{
  FDATE fdateCreation;
  FTIME ftimeCreation;
  FDATE fdateLastAccess;
  FTIME ftimeLastAccess;
  FDATE fdateLastWrite;
  FTIME ftimeLastWrite;
  ULONG cbFile;
  ULONG cbFileAlloc;
  ULONG attrFile;
} FILESTATUS3;
typedef FILESTATUS3 *PFILESTATUS3;

typedef struct _FILESTATUS4
{
  FDATE fdateCreation;
  FTIME ftimeCreation;
  FDATE fdateLastAccess;
  FTIME ftimeLastAccess;
  FDATE fdateLastWrite;
  FTIME ftimeLastWrite;
  ULONG cbFile;
  ULONG cbFileAlloc;
  ULONG attrFile;
  ULONG cbList;
} FILESTATUS4;
typedef FILESTATUS4 *PFILESTATUS4;

typedef struct _FILESTATUS3L
{
   FDATE fdateCreation;
   FTIME ftimeCreation;
   FDATE fdateLastAccess;
   FTIME ftimeLastAccess;
   FDATE fdateLastWrite;
   FTIME ftimeLastWrite;
   LONGLONG cbFile;
   LONGLONG cbFileAlloc;
   ULONG attrFile;
} FILESTATUS3L;
typedef FILESTATUS3L *PFILESTATUS3L;

typedef struct _FILESTATUS4L
{
   FDATE fdateCreation;
   FTIME ftimeCreation;
   FDATE fdateLastAccess;
   FTIME ftimeLastAccess;
   FDATE fdateLastWrite;
   FTIME ftimeLastWrite;
   LONGLONG cbFile;
   LONGLONG cbFileAlloc;
   ULONG attrFile;
   ULONG cbList;
} FILESTATUS4L;
typedef FILESTATUS4L *PFILESTATUS4L;

typedef struct _FSALLOCATE
{
  ULONG idFileSystem;
  ULONG cSectorUnit;
  ULONG cUnit;
  ULONG cUnitAvail;
  USHORT cbSector;
} FSALLOCATE;
typedef FSALLOCATE *PFSALLOCATE;

typedef struct _FSQBUFFER
{
  USHORT iType;
  USHORT cbName;
  UCHAR szName[1];
  USHORT cbFSDName;
  UCHAR szFSDName[1];
  USHORT cbFSAData;
  UCHAR rgFSAData[1];
} FSQBUFFER;
typedef FSQBUFFER *PFSQBUFFER;

typedef struct _FSQBUFFER2
{
  USHORT iType;
  USHORT cbName;
  USHORT cbFSDName;
  USHORT cbFSAData;
  UCHAR szName[1];
  UCHAR szFSDName[1];
  UCHAR rgFSAData[1];
} FSQBUFFER2;
typedef FSQBUFFER2 *PFSQBUFFER2;

typedef struct _SPOOLATTACH
{
  USHORT hNmPipe;
  ULONG ulKey;
} SPOOLATTACH;
typedef SPOOLATTACH *PSPOOLATTACH;

typedef struct _VOLUMELABEL
{
  BYTE cch;
  CHAR szVolLabel[12];
} VOLUMELABEL;
typedef VOLUMELABEL *PVOLUMELABEL;

typedef struct _FSINFO
{
  FDATE fdateCreation;
  FTIME ftimeCreation;
  VOLUMELABEL vol;
} FSINFO;
typedef FSINFO *PFSINFO;

typedef struct _LISTIO_CB
{
  HFILE hFile;
  ULONG CmdFlag;
  LONG Offset;
  PVOID pBuffer;
  ULONG NumBytes;
  ULONG Actual;
  ULONG RetCode;
  ULONG Reserved;
  ULONG Reserved2[3];
  ULONG Reserved3[2];
} LISTIO;
typedef LISTIO *PLISTIO;

typedef struct _LISTIO_CBL
{
  HFILE hFile;
  ULONG CmdFlag;
  LONGLONG Offset;
  PVOID pBuffer;
  ULONG NumBytes;
  ULONG Actual;
  ULONG RetCode;
  ULONG Reserved;
  ULONG Reserved2[3];
  ULONG Reserved3[2];
} LISTIOL;
typedef LISTIOL *PLISTIOL;

ULONG __attribute__((__system__)) DosCancelLockRequest (HFILE hFile, __const__ FILELOCK *pfl);
ULONG __attribute__((__system__)) DosCancelLockRequestL (HFILE hFile, __const__ FILELOCKL *pfl);
ULONG __attribute__((__system__)) DosClose (HFILE hFile);
ULONG __attribute__((__system__)) DosCopy (PCSZ pszSource, PCSZ pszTarget, ULONG ulOption);
ULONG __attribute__((__system__)) DosCreateDir (PCSZ pszDirName, PEAOP2 pEABuf);
ULONG __attribute__((__system__)) DosDelete (PCSZ pszFileName);
ULONG __attribute__((__system__)) DosDeleteDir (PCSZ pszDirName);
ULONG __attribute__((__system__)) DosDupHandle (HFILE hFile, PHFILE phFile);
ULONG __attribute__((__system__)) DosEditName (ULONG ulLevel, PCSZ pszSource, PCSZ pszEdit,
    PBYTE pszTargetBuf, ULONG ulTargetBufLength);
ULONG __attribute__((__system__)) DosEnumAttribute (ULONG ulRefType, CPVOID pvFile, ULONG ulEntry,
    PVOID pvBuf, ULONG ulBufLength, PULONG pulCount, ULONG ulInfoLevel);
ULONG __attribute__((__system__)) DosFindClose (HDIR hDir);
ULONG __attribute__((__system__)) DosFindFirst (PCSZ pszFileSpec, PHDIR phDir, ULONG flAttribute,
    PVOID pFindBuf, ULONG ulFindBufLength, PULONG pulFileNames,
    ULONG ulInfoLevel);
ULONG __attribute__((__system__)) DosFindNext (HDIR hDir, PVOID pFindBuf, ULONG ulFindBufLength,
    PULONG pulFileNames);
ULONG __attribute__((__system__)) DosForceDelete (PCSZ pszFileName);
ULONG __attribute__((__system__)) DosFSAttach (PCSZ pszDevice, PCSZ pszFilesystem,
    __const__ void *pData, ULONG ulDataLength, ULONG ulFlag);
ULONG __attribute__((__system__)) DosFSCtl (PVOID pData, ULONG ulDataLengthMax, PULONG pulDataLength,
    PVOID pParmList, ULONG ulParmLengthMax, PULONG pulParmLength,
    ULONG ulFunction, PCSZ pszRouteName, HFILE hFile, ULONG ulMethod);
ULONG __attribute__((__system__)) DosListIO (ULONG ulCmdMode, ULONG cEntries, PLISTIO pListIO);
ULONG __attribute__((__system__)) DosListIOL (ULONG ulCmdMode, ULONG cEntries, PLISTIOL pListIO);
ULONG __attribute__((__system__)) DosMove (PCSZ pszOldName, PCSZ pszNewName);
ULONG __attribute__((__system__)) DosOpen (PCSZ pszFileName, PHFILE phFile, PULONG pulAction,
    ULONG ulFileSize, ULONG ulAttribute, ULONG ulOpenFlags, ULONG ulOpenMode,
    PEAOP2 pEABuf);
ULONG __attribute__((__system__)) DosOpenL (PCSZ pszFileName, PHFILE phFile, PULONG pulAction,
    LONGLONG llFileSize, ULONG ulAttribute, ULONG ulOpenFlags, ULONG ulOpenMode,
    PEAOP2 pEABuf);
ULONG __attribute__((__system__)) DosProtectClose (HFILE hFile, FHLOCK fhFileHandleLockID);
ULONG __attribute__((__system__)) DosProtectEnumAttribute (ULONG ulRefType, CPVOID pvFile,
    ULONG ulEntry, PVOID pvBuf, ULONG ulBufLength, PULONG pulCount,
    ULONG ulInfoLevel, FHLOCK fhFileHandleLockID);
ULONG __attribute__((__system__)) DosProtectOpen (PCSZ pszFileName, PHFILE phFile, PULONG pulAction,
    ULONG cbFile, ULONG ulAttribute, ULONG ulOpenFlags, ULONG ulOpenMode,
    PEAOP2 pEABuf, PFHLOCK pfhFileHandleLockID);
ULONG __attribute__((__system__)) DosProtectOpenL (PCSZ pszFileName, PHFILE phFile, PULONG pulAction,
    LONGLONG cbFile, ULONG ulAttribute, ULONG flOpenFlags, ULONG flOpenMode,
    PEAOP2 peaop2, PFHLOCK pfhFileHandleLockID);
ULONG __attribute__((__system__)) DosProtectQueryFHState (HFILE hFile, PULONG pulMode,
    FHLOCK fhFileHandleLockID);
ULONG __attribute__((__system__)) DosProtectQueryFileInfo (HFILE hFile, ULONG ulInfoLevel,
    PVOID pInfoBuffer, ULONG ulInfoLength, FHLOCK fhFileHandleLockID);
ULONG __attribute__((__system__)) DosProtectRead (HFILE hFile, PVOID pBuffer, ULONG ulLength,
    PULONG pulBytesRead, FHLOCK fhFileHandleLockID);
ULONG __attribute__((__system__)) DosProtectSetFHState (HFILE hFile, ULONG ulMode,
    FHLOCK fhFileHandleLockID);
ULONG __attribute__((__system__)) DosProtectSetFileInfo (HFILE hFile, ULONG ulInfoLevel, PVOID pInfoBuffer,
    ULONG ulInfoLength, FHLOCK fhFileHandleLockID);
ULONG __attribute__((__system__)) DosProtectSetFileLocks (HFILE hFile, __const__ FILELOCK *pflUnlock,
    __const__ FILELOCK *pflLock, ULONG ulTimeout, ULONG flFlags,
    FHLOCK fhFileHandleLockID);
ULONG __attribute__((__system__)) DosProtectSetFileLocksL (HFILE hFile, __const__ FILELOCKL *pflUnlock,
    __const__ FILELOCKL *pflLock, ULONG ulTimeout, ULONG flFlags,
    FHLOCK fhFileHandleLockID);
ULONG __attribute__((__system__)) DosProtectSetFilePtr (HFILE hFile, LONG lOffset, ULONG ulOrigin,
    PULONG pulPos, FHLOCK fhFileHandleLockID);
ULONG __attribute__((__system__)) DosProtectSetFilePtrL (HFILE hFile, LONGLONG llOffset, ULONG ulOrigin,
    PLONGLONG pllPos, FHLOCK fhFileHandleLockID);
ULONG __attribute__((__system__)) DosProtectSetFileSize (HFILE hFile, ULONG cbSize,
    FHLOCK fhFileHandleLockID);
ULONG __attribute__((__system__)) DosProtectSetFileSizeL (HFILE hFile, LONGLONG cbSize,
    FHLOCK fhFileHandleLockID);
ULONG __attribute__((__system__)) DosProtectWrite (HFILE hFile, CPVOID pBuffer, ULONG ulLength,
    PULONG pulBytesWritten, FHLOCK fhFileHandleLockID);
ULONG __attribute__((__system__)) DosQueryCurrentDir (ULONG ulDrive, PBYTE pPath, PULONG pulPathLength);
ULONG __attribute__((__system__)) DosQueryCurrentDisk (PULONG pulDrive, PULONG pulLogical);
ULONG __attribute__((__system__)) DosQueryFHState (HFILE hFile, PULONG pulMode);
ULONG __attribute__((__system__)) DosQueryFileInfo (HFILE hFile, ULONG ulInfoLevel, PVOID pInfoBuffer,
    ULONG ulInfoLength);
ULONG __attribute__((__system__)) DosQueryFSAttach (PCSZ pszDeviceName, ULONG ulOrdinal,
    ULONG ulFSAInfoLevel, PFSQBUFFER2 pfsqb, PULONG pulBufLength);
ULONG __attribute__((__system__)) DosQueryFSInfo (ULONG ulDrive, ULONG ulInfoLevel, PVOID pBuf,
    ULONG ulBufLength);
ULONG __attribute__((__system__)) DosQueryHType (HFILE hFile, PULONG pulType, PULONG pulAttr);
ULONG __attribute__((__system__)) DosQueryPathInfo (PCSZ pszPathName, ULONG ulInfoLevel,
    PVOID pInfoBuffer, ULONG ulInfoLength);
ULONG __attribute__((__system__)) DosQueryVerify (PBOOL32 pVerify);
ULONG __attribute__((__system__)) DosRead (HFILE hFile, PVOID pBuffer, ULONG ulLength,
    PULONG pulBytesRead);
ULONG __attribute__((__system__)) DosResetBuffer (HFILE hf);
ULONG __attribute__((__system__)) DosSetCurrentDir (PCSZ pszDir);
ULONG __attribute__((__system__)) DosSetDefaultDisk (ULONG ulDrive);
ULONG __attribute__((__system__)) DosSetFHState (HFILE hFile, ULONG ulMode);
ULONG __attribute__((__system__)) DosSetFileInfo (HFILE hFile, ULONG ulInfoLevel, PVOID pInfoBuffer,
    ULONG ulInfoLength);
ULONG __attribute__((__system__)) DosSetFileLocks (HFILE hFile, __const__ FILELOCK *pflUnlock,
    __const__ FILELOCK *pflLock, ULONG ulTimeout, ULONG ulFlags);
ULONG __attribute__((__system__)) DosSetFileLocksL (HFILE hFile, __const__ FILELOCKL *pflUnlock,
    __const__ FILELOCKL *pflLock, ULONG ulTimeout, ULONG flFlags);
ULONG __attribute__((__system__)) DosSetFilePtr (HFILE hFile, LONG lOffset, ULONG ulOrigin, PULONG pulPos);
ULONG __attribute__((__system__)) DosSetFilePtrL (HFILE hFile, LONGLONG llOffset, ULONG ulOrigin, PLONGLONG pllPos);
ULONG __attribute__((__system__)) DosSetFileSize (HFILE hFile, ULONG cbSize);
ULONG __attribute__((__system__)) DosSetFileSizeL (HFILE hFile, LONGLONG cbSize);
ULONG __attribute__((__system__)) DosSetFSInfo (ULONG ulDrive, ULONG ulInfoLevel, PVOID pBuf,
    ULONG ulBufLength);
ULONG __attribute__((__system__)) DosSetMaxFH (ULONG ulCount);
ULONG __attribute__((__system__)) DosSetPathInfo (PCSZ pszPathName, ULONG ulInfoLevel, PVOID pInfoBuffer,
    ULONG ulInfoLength, ULONG ulOptions);
ULONG __attribute__((__system__)) DosSetRelMaxFH (PLONG pulReqCount, PULONG pulCurMaxFH);
ULONG __attribute__((__system__)) DosSetVerify (BOOL32 f32Verify);
ULONG __attribute__((__system__)) DosShutdown (ULONG ulReserved);
ULONG __attribute__((__system__)) DosWrite (HFILE hFile, CPVOID pBuffer, ULONG ulLength,
    PULONG pulBytesWritten);
# 2847 "/@unixroot/usr/include/os2emx.h" 3 4
ULONG __attribute__((__system__)) DosFreeResource (PVOID pResAddr);
ULONG __attribute__((__system__)) DosGetResource (HMODULE hmod, ULONG ulTypeID, ULONG ulNameID,
    PPVOID pOffset);
ULONG __attribute__((__system__)) DosQueryResourceSize (HMODULE hmod, ULONG ulTypeID, ULONG ulNameID,
    PULONG pulSize);
# 2862 "/@unixroot/usr/include/os2emx.h" 3 4
ULONG __attribute__((__system__)) DosBeep (ULONG ulFrequency, ULONG ulDuration);
void __attribute__((__system__)) DosExit (ULONG ulAction, ULONG ulResult) __attribute__ ((__noreturn__));
# 2919 "/@unixroot/usr/include/os2emx.h" 3 4
typedef struct _RESULTCODES
{
  ULONG codeTerminate;
  ULONG codeResult;
} RESULTCODES;
typedef RESULTCODES *PRESULTCODES;

typedef struct tib2_s
{
  ULONG tib2_ultid;
  ULONG tib2_ulpri;
  ULONG tib2_version;
  USHORT tib2_usMCCount;
  USHORT tib2_fMCForceFlag;
} TIB2;
typedef TIB2 *PTIB2;

typedef struct tib_s
{
  PVOID tib_pexchain;
  PVOID tib_pstack;
  PVOID tib_pstacklimit;
  PTIB2 tib_ptib2;
  ULONG tib_version;
  ULONG tib_ordinal;
} TIB;
typedef TIB *PTIB;

typedef struct pib_s
{
  ULONG pib_ulpid;
  ULONG pib_ulppid;
  ULONG pib_hmte;
  PCHAR pib_pchcmd;
  PCHAR pib_pchenv;
  ULONG pib_flstatus;
  ULONG pib_ultype;
} PIB;
typedef PIB *PPIB;




typedef void __attribute__((__system__)) FNTHREAD(ULONG ulThreadArg);

typedef FNTHREAD *PFNTHREAD;




typedef void __attribute__((__system__)) FNEXITLIST(ULONG ulArg);

typedef FNEXITLIST *PFNEXITLIST;

typedef struct _MPAFFINITY
{
  ULONG mask[2];
} MPAFFINITY;
typedef MPAFFINITY *PMPAFFINITY;

typedef struct _THREADCREATE
{
  ULONG cbSize;
  PTID pTid;
  PFNTHREAD pfnStart;
  ULONG lParam;
  ULONG lFlag;
  PBYTE pStack;
  ULONG cbStack;
} THREADCREATE;
typedef THREADCREATE *PTHREADCREATE;

ULONG __attribute__((__system__)) DosAllocThreadLocalMemory (ULONG cb, PULONG *p);
ULONG __attribute__((__system__)) DosCreateThread (PTID ptidThreadID, PFNTHREAD pfnThreadAddr,
    ULONG ulThreadArg, ULONG ulFlags, ULONG ulStackSize);
ULONG __attribute__((__system__)) DosCreateThread2 (PTHREADCREATE ptc);
ULONG __attribute__((__system__)) DosEnterCritSec (void);
ULONG __attribute__((__system__)) DosExecPgm (PCHAR pObjname, LONG lObjnameLength, ULONG ulFlagS,
    PCSZ pszArg, PCSZ pszEnv, PRESULTCODES pReturnCodes, PCSZ pszName);
ULONG __attribute__((__system__)) DosExitCritSec (void);
ULONG __attribute__((__system__)) DosExitList (ULONG ulOrder, PFNEXITLIST pfn);
ULONG __attribute__((__system__)) DosFreeThreadLocalMemory (ULONG *p);
ULONG __attribute__((__system__)) DosGetInfoBlocks (PTIB *ptib, PPIB *ppib);
ULONG __attribute__((__system__)) DosKillProcess (ULONG ulAction, PID pid);
ULONG __attribute__((__system__)) DosKillThread (TID tid);
ULONG __attribute__((__system__)) DosQueryThreadAffinity (ULONG ulScope, PMPAFFINITY pAffinity);
ULONG __attribute__((__system__)) DosResumeThread (TID tid);
ULONG __attribute__((__system__)) DosSetPriority (ULONG ulScope, ULONG ulClass, LONG lDelta, ULONG ulID);
ULONG __attribute__((__system__)) DosSetThreadAffinity (PMPAFFINITY pAffinity);
ULONG __attribute__((__system__)) DosSleep (ULONG ulInterval);
ULONG __attribute__((__system__)) DosSuspendThread (TID tid);
ULONG __attribute__((__system__)) DosVerifyPidTid (PID pid, TID tid);
ULONG __attribute__((__system__)) DosWaitChild (ULONG ulAction, ULONG ulWait, PRESULTCODES pReturnCodes,
    PPID ppidOut, PID pidIn);
ULONG __attribute__((__system__)) DosWaitThread (PTID ptid, ULONG ulWait);
# 3151 "/@unixroot/usr/include/os2emx.h" 3 4
typedef ULONG HEV;
typedef HEV *PHEV;

typedef struct _PSEMRECORD
{
  HSEM hsemCur;
  ULONG ulUser;
} SEMRECORD;
typedef SEMRECORD *PSEMRECORD;
# 3234 "/@unixroot/usr/include/os2emx.h" 3 4
typedef struct _AVAILDATA
{
  USHORT cbpipe;
  USHORT cbmessage;
} AVAILDATA;
typedef AVAILDATA *PAVAILDATA;

typedef struct _PIPEINFO
{
  USHORT cbOut;
  USHORT cbIn;
  BYTE cbMaxInst;
  BYTE cbCurInst;
  BYTE cbName;
  CHAR szName[1];
} PIPEINFO;
typedef PIPEINFO *PPIPEINFO;

typedef struct _PIPESEMSTATE
{
  BYTE fStatus;
  BYTE fFlag;
  USHORT usKey;
  USHORT usAvail;
} PIPESEMSTATE;
typedef PIPESEMSTATE *PPIPESEMSTATE;

ULONG __attribute__((__system__)) DosCallNPipe (PCSZ pszName, PVOID pInbuf, ULONG ulInbufLength,
    PVOID pOutbuf, ULONG ulOutbufSize, PULONG pulActualLength,
    ULONG ulTimeout);
ULONG __attribute__((__system__)) DosConnectNPipe (HPIPE hpipe);
ULONG __attribute__((__system__)) DosCreateNPipe (PCSZ pszName, PHPIPE phpipe, ULONG ulOpenMode,
    ULONG ulPipeMode, ULONG ulInbufLength, ULONG ulOutbufLength,
    ULONG ulTimeout);
ULONG __attribute__((__system__)) DosDisConnectNPipe (HPIPE hpipe);
ULONG __attribute__((__system__)) DosPeekNPipe (HPIPE hpipe, PVOID pBuf, ULONG ulBufLength,
    PULONG pulActualLength, PAVAILDATA pAvail, PULONG pulState);
ULONG __attribute__((__system__)) DosQueryNPHState (HPIPE hpipe, PULONG pulState);
ULONG __attribute__((__system__)) DosQueryNPipeInfo (HPIPE hpipe, ULONG ulInfoLevel, PVOID pBuf,
    ULONG ulBufLength);
ULONG __attribute__((__system__)) DosQueryNPipeSemState (HSEM hsem, PPIPESEMSTATE pState,
    ULONG ulBufLength);
ULONG __attribute__((__system__)) DosRawReadNPipe (PCSZ pszName, ULONG ulCount, PULONG pulLength,
    PVOID pBuf);
ULONG __attribute__((__system__)) DosRawWriteNPipe (PCSZ pszName, ULONG ulCount);
ULONG __attribute__((__system__)) DosSetNPHState (HPIPE hpipe, ULONG ulState);
ULONG __attribute__((__system__)) DosSetNPipeSem (HPIPE hpipe, HSEM hsem, ULONG ulKey);
ULONG __attribute__((__system__)) DosTransactNPipe (HPIPE hpipe, PVOID pOutbuf, ULONG ulOutbufLength,
    PVOID pInbuf, ULONG ulInbufLength, PULONG pulBytesRead);
ULONG __attribute__((__system__)) DosWaitNPipe (PCSZ pszName, ULONG ulTimeout);
# 3569 "/@unixroot/usr/include/os2emx.h" 3 4
typedef struct _DATETIME
{
  UCHAR hours;
  UCHAR minutes;
  UCHAR seconds;
  UCHAR hundredths;
  UCHAR day;
  UCHAR month;
  USHORT year;
  SHORT timezone;
  UCHAR weekday;
} DATETIME;
typedef DATETIME *PDATETIME;

ULONG __attribute__((__system__)) DosGetDateTime (PDATETIME pdt);
ULONG __attribute__((__system__)) DosSetDateTime (__const__ DATETIME *pdt);
# 3893 "/@unixroot/usr/include/os2emx.h" 3 4
typedef USHORT SGID;
# 4028 "/@unixroot/usr/include/os2emx.h" 3 4
typedef struct _TStat
{
  UCHAR DbgState;
  UCHAR TState;
  USHORT TPriority;
} TStat_t;

typedef struct _uDB
{
  ULONG Pid;
  ULONG Tid;
  LONG Cmd;
  LONG Value;
  ULONG Addr;
  ULONG Buffer;
  ULONG Len;
  ULONG Index;
  ULONG MTE;
  ULONG EAX;
  ULONG ECX;
  ULONG EDX;
  ULONG EBX;
  ULONG ESP;
  ULONG EBP;
  ULONG ESI;
  ULONG EDI;
  ULONG EFlags;
  ULONG EIP;
  ULONG CSLim;
  ULONG CSBase;
  UCHAR CSAcc;
  UCHAR CSAtr;
  USHORT CS;
  ULONG DSLim;
  ULONG DSBase;
  UCHAR DSAcc;
  UCHAR DSAtr;
  USHORT DS;
  ULONG ESLim;
  ULONG ESBase;
  UCHAR ESAcc;
  UCHAR ESAtr;
  USHORT ES;
  ULONG FSLim;
  ULONG FSBase;
  UCHAR FSAcc;
  UCHAR FSAtr;
  USHORT FS;
  ULONG GSLim;
  ULONG GSBase;
  UCHAR GSAcc;
  UCHAR GSAtr;
  USHORT GS;
  ULONG SSLim;
  ULONG SSBase;
  UCHAR SSAcc;
  UCHAR SSAtr;
  USHORT SS;
} uDB_t;

ULONG __attribute__((__system__)) DosDebug (uDB_t *pDebugBuffer);
# 5356 "/@unixroot/usr/include/os2emx.h" 3 4
typedef LHANDLE HACCEL;

typedef LHANDLE HRGN;
typedef HRGN *PHRGN;

typedef void *MRESULT;
typedef MRESULT *PMRESULT;

typedef void *MPARAM;
typedef MPARAM *PMPARAM;

typedef LHANDLE HPOINTER;

typedef HMODULE HLIB;
typedef HLIB *PHLIB;

typedef LONG COLOR;
typedef COLOR *PCOLOR;

typedef LHANDLE HAB;
typedef HAB *PHAB;

typedef LHANDLE HPS;
typedef HPS *PHPS;

typedef LHANDLE HDC;
typedef HDC *PHDC;

typedef LHANDLE HWND;
typedef HWND *PHWND;

typedef LHANDLE HMQ;

typedef LHANDLE HPAL;
typedef HPAL *PHPAL;

typedef LHANDLE HBITMAP;
typedef HBITMAP *PHBITMAP;

typedef ULONG ERRORID;
typedef ERRORID *PERRORID;




typedef MRESULT (__attribute__((__system__)) FNWP) (HWND hwnd, ULONG msg, MPARAM mp1, MPARAM mp2);

typedef FNWP *PFNWP;





typedef struct _POINTL
{
  LONG x;
  LONG y;
} POINTL;
typedef POINTL *PPOINTL;

typedef struct _POINTS
{
  SHORT x;
  SHORT y;
} POINTS;
typedef POINTS *PPOINTS;

typedef struct _RECTL
{
  LONG xLeft;
  LONG yBottom;
  LONG xRight;
  LONG yTop;
} RECTL;
typedef RECTL *PRECTL;
# 5764 "/@unixroot/usr/include/os2emx.h" 3 4
typedef struct _QMSG
{
  HWND hwnd;
  ULONG msg;
  MPARAM mp1;
  MPARAM mp2;
  ULONG time;
  POINTL ptl;
  ULONG reserved;
} QMSG;
typedef QMSG *PQMSG;

typedef struct _COMMANDMSG
{
  USHORT cmd;
  USHORT unused;
  USHORT source;
  USHORT fMouse;
} CMDMSG;
typedef CMDMSG *PCMDMSG;

typedef struct _MQINFO
{
  ULONG cb;
  PID pid;
  TID tid;
  ULONG cmsgs;
  PVOID pReserved;
} MQINFO;
typedef MQINFO *PMQINFO;




BOOL __attribute__((__system__)) WinCancelShutdown (HMQ hmq, BOOL fCancelAlways);
HMQ __attribute__((__system__)) WinCreateMsgQueue (HAB hab, LONG cmsg);
BOOL __attribute__((__system__)) WinDestroyMsgQueue (HMQ hmq);
MRESULT __attribute__((__system__)) WinDispatchMsg (HAB hab, PQMSG pqmsg);
BOOL __attribute__((__system__)) WinGetMsg (HAB hab, PQMSG pqmsg, HWND hwndFilter, ULONG msgFilterFirst,
    ULONG msgFilterLast);
BOOL __attribute__((__system__)) WinLockInput (HMQ hmq, ULONG fLock);
BOOL __attribute__((__system__)) WinPeekMsg (HAB hab, PQMSG pqmsg, HWND hwndFilter, ULONG msgFilterFirst,
    ULONG msgFilterLast, ULONG fl);
BOOL __attribute__((__system__)) WinPostMsg (HWND hwnd, ULONG msg, MPARAM mp1, MPARAM mp2);
HMQ __attribute__((__system__)) WinQueueFromID (HAB hab, PID pid, TID tid);
BOOL __attribute__((__system__)) WinQueryQueueInfo (HMQ hmq, PMQINFO pmqi, ULONG cbCopy);
HMQ __attribute__((__system__)) WinQuerySendMsg (HAB hab, HMQ hmqSender, HMQ hmqReceiver, PQMSG pqmsg);
BOOL __attribute__((__system__)) WinRegisterUserDatatype (HAB hab, LONG datatype, LONG count, PLONG types);
BOOL __attribute__((__system__)) WinRegisterUserMsg (HAB hab, ULONG msgid, LONG datatype1, LONG dir1,
    LONG datatype2, LONG dir2, LONG datatyper);
BOOL __attribute__((__system__)) WinReplyMsg (HAB hab, HMQ hmqSender, HMQ hmqReceiver, MRESULT mresult);
MRESULT __attribute__((__system__)) WinSendMsg (HWND hwnd, ULONG msg, MPARAM mp1, MPARAM mp2);
BOOL __attribute__((__system__)) WinSetMsgMode (HAB hab, PCSZ classname, LONG control);
BOOL __attribute__((__system__)) WinSetSynchroMode (HAB hab, LONG mode);
BOOL __attribute__((__system__)) WinThreadAssocQueue (HAB hab, HMQ hmq);
BOOL __attribute__((__system__)) WinWakeThread (HMQ hmq);



typedef struct _SWP
{
  ULONG fl;
  LONG cy;
  LONG cx;
  LONG y;
  LONG x;
  HWND hwndInsertBehind;
  HWND hwnd;
  ULONG ulReserved1;
  ULONG ulReserved2;
} SWP;
typedef SWP *PSWP;

typedef struct _ICONINFO
{
   ULONG cb;
   ULONG fFormat;
   PSZ pszFileName;
   HMODULE hmod;
   ULONG resid;
   ULONG cbIconData;
   PVOID pIconData;
} ICONINFO;
typedef ICONINFO *PICONINFO;
# 5881 "/@unixroot/usr/include/os2emx.h" 3 4
HWND __attribute__((__system__)) WinCreateWindow (HWND hwndParent, PCSZ pszClass, PCSZ pszName,
    ULONG flStyle, LONG x, LONG y, LONG cx, LONG cy, HWND hwndOwner,
    HWND hwndInsertBehind, ULONG id, PVOID pCtlData, PVOID pPresParams);
BOOL __attribute__((__system__)) WinDrawBitmap (HPS hpsDst, HBITMAP hbm, __const__ RECTL *pwrcSrc,
    __const__ POINTL *pptlDst, LONG clrFore, LONG clrBack, ULONG fl);
BOOL __attribute__((__system__)) WinDrawBorder (HPS hps, __const__ RECTL *prcl, LONG cx, LONG cy,
    LONG clrFore, LONG clrBack, ULONG flCmd);
LONG __attribute__((__system__)) WinDrawText (HPS hps, LONG cchText, PCCH lpchText, PRECTL prcl,
    LONG clrFore, LONG clrBack, ULONG flCmd);
BOOL __attribute__((__system__)) WinEnableWindow (HWND hwnd, BOOL fEnable);
BOOL __attribute__((__system__)) WinEnableWindowUpdate (HWND hwnd, BOOL fEnable);
BOOL __attribute__((__system__)) WinInvalidateRect (HWND hwnd, __const__ RECTL *prcl,
    BOOL fIncludeChildren);
BOOL __attribute__((__system__)) WinInvalidateRegion (HWND hwnd, HRGN hrgn, BOOL fIncludeChildren);
BOOL __attribute__((__system__)) WinInvertRect (HPS hps, __const__ RECTL *prcl);
BOOL __attribute__((__system__)) WinIsChild (HWND hwnd, HWND hwndParent);
BOOL __attribute__((__system__)) WinIsWindow (HAB hab, HWND hwnd);
BOOL __attribute__((__system__)) WinIsWindowEnabled (HWND hwnd);
BOOL __attribute__((__system__)) WinIsWindowVisible (HWND hwnd);
LONG __attribute__((__system__)) WinLoadMessage (HAB hab, HMODULE hmod, ULONG id, LONG cchMax,
    PSZ pchBuffer);
LONG __attribute__((__system__)) WinLoadString (HAB hab, HMODULE hmod, ULONG id, LONG cchMax,
    PSZ pchBuffer);
LONG __attribute__((__system__)) WinMultWindowFromIDs (HWND hwndParent, PHWND prghwnd, ULONG idFirst,
    ULONG idLast);
HWND __attribute__((__system__)) WinQueryDesktopWindow (HAB hab, HDC hdc);
HWND __attribute__((__system__)) WinQueryObjectWindow (HWND hwndDesktop);
HPOINTER __attribute__((__system__)) WinQueryPointer (HWND hwndDesktop);
HWND __attribute__((__system__)) WinQueryWindow (HWND hwnd, LONG cmd);
BOOL __attribute__((__system__)) WinQueryWindowPos (HWND hwnd, PSWP pswp);
BOOL __attribute__((__system__)) WinQueryWindowProcess (HWND hwnd, PPID ppid, PTID ptid);
LONG __attribute__((__system__)) WinQueryWindowText (HWND hwnd, LONG cchBufferMax, PCH pchBuffer);
LONG __attribute__((__system__)) WinQueryWindowTextLength (HWND hwnd);
BOOL __attribute__((__system__)) WinSetMultWindowPos (HAB hab, __const__ SWP *pswp, ULONG cswp);
BOOL __attribute__((__system__)) WinSetOwner (HWND hwnd, HWND hwndNewOwner);
BOOL __attribute__((__system__)) WinSetParent (HWND hwnd, HWND hwndNewParent, BOOL fRedraw);
BOOL __attribute__((__system__)) WinSetWindowPos (HWND hwnd, HWND hwndInsertBehind, LONG x, LONG y,
    LONG cx, LONG cy, ULONG fl);
BOOL __attribute__((__system__)) WinSetWindowText (HWND hwnd, PCSZ pszText);
BOOL __attribute__((__system__)) WinUpdateWindow (HWND hwnd);
HWND __attribute__((__system__)) WinWindowFromID (HWND hwndParent, ULONG id);
# 5989 "/@unixroot/usr/include/os2emx.h" 3 4
typedef struct _FRAMECDATA
{
  USHORT cb;
  ULONG flCreateFlags;
  USHORT hmodResources;
  USHORT idResources;
} FRAMECDATA;
typedef FRAMECDATA *PFRAMECDATA;

HWND __attribute__((__system__)) WinCreateStdWindow (HWND hwndParent, ULONG flStyle,
    PULONG pflCreateFlags, PCSZ pszClientClass, PCSZ pszTitle,
    ULONG styleClient, HMODULE hmod, ULONG idResources, PHWND phwndClient);
# 6113 "/@unixroot/usr/include/os2emx.h" 3 4
typedef struct _QVERSDATA
{
  USHORT environment;
  USHORT version;
} QVERSDATA;
typedef QVERSDATA *PQVERSDATA;


HPS __attribute__((__system__)) WinBeginPaint (HWND hwnd, HPS hps, PRECTL prclPaint);
MRESULT __attribute__((__system__)) WinDefWindowProc (HWND hwnd, ULONG msg, MPARAM mp1, MPARAM mp2);
BOOL __attribute__((__system__)) WinDestroyWindow (HWND hwnd);
BOOL __attribute__((__system__)) WinEndPaint (HPS hps);
BOOL __attribute__((__system__)) WinFillRect (HPS hps, __const__ RECTL *prcl, LONG lColor);
HPS __attribute__((__system__)) WinGetClipPS (HWND hwnd, HWND hwndClip, ULONG fl);
HPS __attribute__((__system__)) WinGetPS (HWND hwnd);
HAB __attribute__((__system__)) WinInitialize (ULONG fsOptions);
BOOL __attribute__((__system__)) WinIsWindowShowing (HWND hwnd);
HDC __attribute__((__system__)) WinOpenWindowDC (HWND hwnd);
HAB __attribute__((__system__)) WinQueryAnchorBlock (HWND hwnd);
ULONG __attribute__((__system__)) WinQueryVersion (HAB hab);
BOOL __attribute__((__system__)) WinQueryWindowRect (HWND hwnd, PRECTL prclDest);
BOOL __attribute__((__system__)) WinRegisterClass (HAB hab, PCSZ pszClassName, PFNWP pfnWndProc,
    ULONG flStyle, ULONG cbWindowData);
BOOL __attribute__((__system__)) WinReleasePS (HPS hps);
LONG __attribute__((__system__)) WinScrollWindow (HWND hwnd, LONG dx, LONG dy, __const__ RECTL *prclScroll,
    __const__ RECTL *prclClip, HRGN hrgnUpdate, PRECTL prclUpdate,
    ULONG rgfsw);
BOOL __attribute__((__system__)) WinSetActiveWindow (HWND hwndDesktop, HWND hwnd);
BOOL __attribute__((__system__)) WinShowWindow (HWND hwnd, BOOL fShow);
BOOL __attribute__((__system__)) WinTerminate (HAB hab);
# 6582 "/@unixroot/usr/include/os2emx.h" 3 4
BOOL __attribute__((__system__)) WinCreateCursor (HWND hwnd, LONG x, LONG y, LONG cx, LONG cy,
    ULONG fs, PRECTL prclClip);
BOOL __attribute__((__system__)) WinDestroyCursor (HWND hwnd);
BOOL __attribute__((__system__)) WinShowCursor (HWND hwnd, BOOL fShow);
# 6707 "/@unixroot/usr/include/os2emx.h" 3 4
typedef struct _MB2D
{
  CHAR achText[70 +1];
  CHAR _pad[1];
  ULONG idButton;
  LONG flStyle;
} MB2D;
typedef MB2D *PMB2D;

typedef struct _MB2INFO
{
  ULONG cb;
  HPOINTER hIcon;
  ULONG cButtons;
  ULONG flStyle;
  HWND hwndNotify;
  MB2D mb2d[1];
} MB2INFO;

typedef MB2INFO *PMB2INFO;
# 6744 "/@unixroot/usr/include/os2emx.h" 3 4
BOOL __attribute__((__system__)) WinAlarm (HWND hwndDesktop, ULONG rgfType);
MRESULT __attribute__((__system__)) WinDefDlgProc (HWND hwndDlg, ULONG msg, MPARAM mp1, MPARAM mp2);
BOOL __attribute__((__system__)) WinDismissDlg (HWND hwndDlg, ULONG usResult);
ULONG __attribute__((__system__)) WinDlgBox (HWND hwndParent, HWND hwndOwner, PFNWP pfnDlgProc,
    HMODULE hmod, ULONG idDlg, PVOID pCreateParams);
BOOL __attribute__((__system__)) WinGetDlgMsg (HWND hwndDlg, PQMSG pqmsg);
HWND __attribute__((__system__)) WinLoadDlg (HWND hwndParent, HWND hwndOwner, PFNWP pfnDlgProc,
    HMODULE hmod, ULONG idDlg, PVOID pCreateParams);
ULONG __attribute__((__system__)) WinMessageBox (HWND hwndParent, HWND hwndOwner, PCSZ pszText,
    PCSZ pszCaption, ULONG idWindow, ULONG flStyle);
ULONG __attribute__((__system__)) WinMessageBox2 (HWND hwndParent, HWND hwndOwner, PCSZ pszText,
    PCSZ pszCaption, ULONG idWindow, PMB2INFO pmb2info);
BOOL __attribute__((__system__)) WinQueryDlgItemShort (HWND hwndDlg, ULONG idItem, PSHORT pResult,
    BOOL fSigned);
ULONG __attribute__((__system__)) WinQueryDlgItemText (HWND hwndDlg, ULONG idItem, LONG cchBufferMax,
    PSZ pchBuffer);
LONG __attribute__((__system__)) WinQueryDlgItemTextLength (HWND hwndDlg, ULONG idItem);
BOOL __attribute__((__system__)) WinSetDlgItemShort (HWND hwndDlg, ULONG idItem, USHORT usValue,
    BOOL fSigned);
BOOL __attribute__((__system__)) WinSetDlgItemText (HWND hwndDlg, ULONG idItem, PCSZ pszText);
# 7034 "/@unixroot/usr/include/os2emx.h" 3 4
BOOL __attribute__((__system__)) WinFocusChange (HWND hwndDesktop, HWND hwndSetFocus, ULONG flFocusChange);
BOOL __attribute__((__system__)) WinLockupSystem (HAB hab);
BOOL __attribute__((__system__)) WinSetFocus (HWND hwndDesktop, HWND hwndSetFocus);
BOOL __attribute__((__system__)) WinUnlockSystem (HAB hab, PCSZ pszPassword);
# 8857 "/@unixroot/usr/include/os2emx.h" 3 4
typedef PVOID PBUNDLE;

typedef LONG FIXED;
typedef FIXED *PFIXED;

typedef LHANDLE HMF;
typedef HMF *PHMF;


typedef struct _SIZEL
{
  LONG cx;
  LONG cy;
} SIZEL;
typedef SIZEL *PSIZEL;

typedef struct _RGNRECT
{
  ULONG ircStart;
  ULONG crc;
  ULONG crcReturned;
  ULONG ulDirection;
} RGNRECT;
typedef RGNRECT *PRGNRECT;

typedef struct _MATRIXLF
{
  FIXED fxM11;
  FIXED fxM12;
  LONG lM13;
  FIXED fxM21;
  FIXED fxM22;
  LONG lM23;
  LONG lM31;
  LONG lM32;
  LONG lM33;
} MATRIXLF;
typedef MATRIXLF *PMATRIXLF;

typedef struct _ARCPARAMS
{
  LONG lP;
  LONG lQ;
  LONG lR;
  LONG lS;
} ARCPARAMS;
typedef ARCPARAMS *PARCPARAMS;

typedef struct _SIZEF
{
  FIXED cx;
  FIXED cy;
} SIZEF;
typedef SIZEF *PSIZEF;

typedef struct _POLYGON
{
  ULONG ulPoints;
  PPOINTL aPointl;
} POLYGON;
typedef POLYGON *PPOLYGON;

typedef struct _POLYSET
{
  ULONG ulPolys;
  POLYGON aPolygon[1];
} POLYSET;
typedef POLYSET *PPOLYSET;

typedef struct _GRADIENTL
{
  LONG x;
  LONG y;
} GRADIENTL;
typedef GRADIENTL *PGRADIENTL;

typedef struct _KERNINGPAIRS
{
  SHORT sFirstChar;
  SHORT sSecondChar;
  LONG lKerningAmount;
} KERNINGPAIRS;
typedef KERNINGPAIRS *PKERNINGPAIRS;

typedef struct _FACENAMEDESC
{
  USHORT usSize;
  USHORT usWeightClass;
  USHORT usWidthClass;
  USHORT usReserved;
  ULONG flOptions;
} FACENAMEDESC;
typedef FACENAMEDESC *PFACENAMEDESC;

typedef CHAR FFDESCS[2][32];
typedef FFDESCS *PFFDESCS;

typedef struct _FFDESCS2
{
  ULONG cbLength;
  ULONG cbFacenameOffset;
  BYTE abFamilyName[1];
} FFDESCS2;
typedef FFDESCS2 *PFFDESCS2;


typedef struct _LINEBUNDLE
{
  LONG lColor;
  LONG lBackColor;
  USHORT usMixMode;
  USHORT usBackMixMode;
  FIXED fxWidth;
  LONG lGeomWidth;
  USHORT usType;
  USHORT usEnd;
  USHORT usJoin;
  USHORT usReserved;
} LINEBUNDLE;
typedef LINEBUNDLE *PLINEBUNDLE;

typedef struct _CHARBUNDLE
{
  LONG lColor;
  LONG lBackColor;
  USHORT usMixMode;
  USHORT usBackMixMode;
  USHORT usSet;
  USHORT usPrecision;
  SIZEF sizfxCell;
  POINTL ptlAngle;
  POINTL ptlShear;
  USHORT usDirection;
  USHORT usTextAlign;
  FIXED fxExtra;
  FIXED fxBreakExtra;
} CHARBUNDLE;
typedef CHARBUNDLE *PCHARBUNDLE;

typedef struct _MARKERBUNDLE
{
  LONG lColor;
  LONG lBackColor;
  USHORT usMixMode;
  USHORT usBackMixMode;
  USHORT usSet;
  USHORT usSymbol;
  SIZEF sizfxCell;
} MARKERBUNDLE;
typedef MARKERBUNDLE *PMARKERBUNDLE;

typedef struct _AREABUNDLE
{
  LONG lColor;
  LONG lBackColor;
  USHORT usMixMode;
  USHORT usBackMixMode;
  USHORT usSet;
  USHORT usSymbol;
  POINTL ptlRefPoint;
} AREABUNDLE;
typedef AREABUNDLE *PAREABUNDLE;

typedef struct _IMAGEBUNDLE
{
  LONG lColor;
  LONG lBackColor;
  USHORT usMixMode;
  USHORT usBackMixMode;
} IMAGEBUNDLE;
typedef IMAGEBUNDLE *PIMAGEBUNDLE;







LONG __attribute__((__system__)) GpiAnimatePalette (HPAL hpal, ULONG ulFormat, ULONG ulStart,
    ULONG ulCount, __const__ ULONG *aulTable);
BOOL __attribute__((__system__)) GpiBeginArea (HPS hps, ULONG flOptions);
BOOL __attribute__((__system__)) GpiBeginElement (HPS hps, LONG lType, PCSZ pszDesc);
BOOL __attribute__((__system__)) GpiBeginPath (HPS hps, LONG lPath);
LONG __attribute__((__system__)) GpiBox (HPS hps, LONG lControl, __const__ POINTL *pptlPoint, LONG lHRound,
    LONG lVRound);
LONG __attribute__((__system__)) GpiCallSegmentMatrix (HPS hps, LONG lSegment, LONG lCount,
    __const__ MATRIXLF *pmatlfArray, LONG lOptions);
LONG __attribute__((__system__)) GpiCharString (HPS hps, LONG lCount, PCCH pchString);
LONG __attribute__((__system__)) GpiCharStringAt (HPS hps, __const__ POINTL *pptlPoint, LONG lCount,
     PCCH pchString);
LONG __attribute__((__system__)) GpiCharStringPos (HPS hps, __const__ RECTL *prclRect, ULONG flOptions,
    LONG lCount, PCCH pchString, __const__ LONG *alAdx);
LONG __attribute__((__system__)) GpiCharStringPosAt (HPS hps, __const__ POINTL *pptlStart,
    __const__ RECTL *prclRect, ULONG flOptions, LONG lCount, PCCH pchString,
    __const__ LONG *alAdx);
BOOL __attribute__((__system__)) GpiCloseFigure (HPS hps);
LONG __attribute__((__system__)) GpiCombineRegion (HPS hps, HRGN hrgnDest, HRGN hrgnSrc1, HRGN hrgnSrc2,
    LONG lMode);
BOOL __attribute__((__system__)) GpiComment (HPS hps, LONG lLength, __const__ BYTE *pbData);
BOOL __attribute__((__system__)) GpiConvert (HPS hps, LONG lSrc, LONG lTarg, LONG lCount,
    PPOINTL aptlPoints);
BOOL __attribute__((__system__)) GpiConvertWithMatrix (HPS hps, LONG lCountp, PPOINTL aptlPoints,
    LONG lCount, __const__ MATRIXLF *pmatlfArray);
HMF __attribute__((__system__)) GpiCopyMetaFile (HMF hmf);
BOOL __attribute__((__system__)) GpiCreateLogColorTable (HPS hps, ULONG flOptions, LONG lFormat,
    LONG lStart, LONG lCount, __const__ LONG *alTable);
LONG __attribute__((__system__)) GpiCreateLogFont (HPS hps, __const__ STR8 *pName, LONG lLcid,
    __const__ FATTRS *pfatAttrs);
HPAL __attribute__((__system__)) GpiCreatePalette (HAB hab, ULONG flOptions, ULONG ulFormat,
    ULONG ulCount, __const__ ULONG *aulTable);
HRGN __attribute__((__system__)) GpiCreateRegion (HPS hps, LONG lCount, __const__ RECTL *arclRectangles);
BOOL __attribute__((__system__)) GpiDeleteElement (HPS hps);
BOOL __attribute__((__system__)) GpiDeleteElementRange (HPS hps, LONG lFirstElement, LONG lLastElement);
BOOL __attribute__((__system__)) GpiDeleteElementsBetweenLabels (HPS hps, LONG lFirstLabel,
    LONG lLastLabel);
BOOL __attribute__((__system__)) GpiDeleteMetaFile (HMF hmf);
BOOL __attribute__((__system__)) GpiDeletePalette (HPAL hpal);
BOOL __attribute__((__system__)) GpiDeleteSetId (HPS hps, LONG lLcid);
BOOL __attribute__((__system__)) GpiDestroyRegion (HPS hps, HRGN hrgn);
LONG __attribute__((__system__)) GpiElement (HPS hps, LONG lType, PCSZ pszDesc, LONG lLength,
    __const__ BYTE *pbData);
LONG __attribute__((__system__)) GpiEndArea (HPS hps);
BOOL __attribute__((__system__)) GpiEndElement (HPS hps);
BOOL __attribute__((__system__)) GpiEndPath (HPS hps);
LONG __attribute__((__system__)) GpiEqualRegion (HPS hps, HRGN hrgnSrc1, HRGN hrgnSrc2);
LONG __attribute__((__system__)) GpiExcludeClipRectangle (HPS hps, __const__ RECTL *prclRectangle);
LONG __attribute__((__system__)) GpiFillPath (HPS hps, LONG lPath, LONG lOptions);
LONG __attribute__((__system__)) GpiFrameRegion (HPS hps, HRGN hrgn, __const__ SIZEL *thickness);
LONG __attribute__((__system__)) GpiFullArc (HPS hps, LONG lControl, FIXED fxMultiplier);
LONG __attribute__((__system__)) GpiImage (HPS hps, LONG lFormat, __const__ SIZEL *psizlImageSize,
    LONG lLength, __const__ BYTE *pbData);
LONG __attribute__((__system__)) GpiIntersectClipRectangle (HPS hps, __const__ RECTL *prclRectangle);
BOOL __attribute__((__system__)) GpiLabel (HPS hps, LONG lLabel);
LONG __attribute__((__system__)) GpiLine (HPS hps, __const__ POINTL *pptlEndPoint);
BOOL __attribute__((__system__)) GpiLoadFonts (HAB hab, PCSZ pszFilename);
HMF __attribute__((__system__)) GpiLoadMetaFile (HAB hab, PCSZ pszFilename);
BOOL __attribute__((__system__)) GpiLoadPublicFonts (HAB hab, PCSZ pszFileName);
LONG __attribute__((__system__)) GpiMarker (HPS hps, __const__ POINTL *pptlPoint);
BOOL __attribute__((__system__)) GpiModifyPath (HPS hps, LONG lPath, LONG lMode);
BOOL __attribute__((__system__)) GpiMove (HPS hps, __const__ POINTL *pptlPoint);
LONG __attribute__((__system__)) GpiOffsetClipRegion (HPS hps, __const__ POINTL *pptlPoint);
BOOL __attribute__((__system__)) GpiOffsetElementPointer (HPS hps, LONG loffset);
BOOL __attribute__((__system__)) GpiOffsetRegion (HPS hps, HRGN Hrgn, __const__ POINTL *pptlOffset);
LONG __attribute__((__system__)) GpiOutlinePath (HPS hps, LONG lPath, LONG lOptions);
LONG __attribute__((__system__)) GpiPaintRegion (HPS hps, HRGN hrgn);
LONG __attribute__((__system__)) GpiPartialArc (HPS hps, __const__ POINTL *pptlCenter, FIXED fxMultiplier,
    FIXED fxStartAngle, FIXED fxSweepAngle);
HRGN __attribute__((__system__)) GpiPathToRegion (HPS GpiH, LONG lPath, LONG lOptions);
LONG __attribute__((__system__)) GpiPlayMetaFile (HPS hps, HMF hmf, LONG lCount1,
    __const__ LONG *alOptarray, PLONG plSegCount, LONG lCount2, PSZ pszDesc);
LONG __attribute__((__system__)) GpiPointArc (HPS hps, __const__ POINTL *pptl2);
LONG __attribute__((__system__)) GpiPolyFillet (HPS hps, LONG lCount, __const__ POINTL *aptlPoints);
LONG __attribute__((__system__)) GpiPolyFilletSharp (HPS hps, LONG lCount, __const__ POINTL *aptlPoints,
    __const__ FIXED *afxPoints);
LONG __attribute__((__system__)) GpiPolygons (HPS hps, ULONG ulCount, __const__ POLYGON *paplgn,
    ULONG flOptions, ULONG flModel);
LONG __attribute__((__system__)) GpiPolyLine (HPS hps, LONG lCount, __const__ POINTL *aptlPoints);
LONG __attribute__((__system__)) GpiPolyLineDisjoint (HPS hps, LONG lCount, __const__ POINTL *aptlPoints);
LONG __attribute__((__system__)) GpiPolyMarker (HPS hps, LONG lCount, __const__ POINTL *aptlPoints);
LONG __attribute__((__system__)) GpiPolySpline (HPS hps, LONG lCount, __const__ POINTL *aptlPoints);
BOOL __attribute__((__system__)) GpiPop (HPS hps, LONG lCount);
LONG __attribute__((__system__)) GpiPtInRegion (HPS hps, HRGN hrgn, __const__ POINTL *pptlPoint);
LONG __attribute__((__system__)) GpiPtVisible (HPS hps, __const__ POINTL *pptlPoint);
BOOL __attribute__((__system__)) GpiQueryArcParams (HPS hps, PARCPARAMS parcpArcParams);
LONG __attribute__((__system__)) GpiQueryAttrMode (HPS hps);
LONG __attribute__((__system__)) GpiQueryAttrs (HPS hps, LONG lPrimType, ULONG flAttrMask,
    PBUNDLE ppbunAttrs);
LONG __attribute__((__system__)) GpiQueryBackColor (HPS hps);
LONG __attribute__((__system__)) GpiQueryBackMix (HPS hps);
BOOL __attribute__((__system__)) GpiQueryCharAngle (HPS hps, PGRADIENTL pgradlAngle);
BOOL __attribute__((__system__)) GpiQueryCharBox (HPS hps, PSIZEF psizfxSize);
BOOL __attribute__((__system__)) GpiQueryCharBreakExtra (HPS hps, PFIXED BreakExtra);
LONG __attribute__((__system__)) GpiQueryCharDirection (HPS hps);
BOOL __attribute__((__system__)) GpiQueryCharExtra (HPS hps, PFIXED Extra);
LONG __attribute__((__system__)) GpiQueryCharMode (HPS hps);
LONG __attribute__((__system__)) GpiQueryCharSet (HPS hps);
BOOL __attribute__((__system__)) GpiQueryCharShear (HPS hps, PPOINTL pptlShear);
BOOL __attribute__((__system__)) GpiQueryCharStringPos (HPS hps, ULONG flOptions, LONG lCount,
    PCCH pchString, PLONG alXincrements, PPOINTL aptlPositions);
BOOL __attribute__((__system__)) GpiQueryCharStringPosAt (HPS hps, PPOINTL pptlStart, ULONG flOptions,
    LONG lCount, PCCH pchString, PLONG alXincrements, PPOINTL aptlPositions);
LONG __attribute__((__system__)) GpiQueryClipBox (HPS hps, PRECTL prclBound);
HRGN __attribute__((__system__)) GpiQueryClipRegion (HPS hps);
LONG __attribute__((__system__)) GpiQueryColor (HPS hps);
BOOL __attribute__((__system__)) GpiQueryColorData (HPS hps, LONG lCount, PLONG alArray);
LONG __attribute__((__system__)) GpiQueryColorIndex (HPS hps, ULONG flOptions, LONG lRgbColor);
ULONG __attribute__((__system__)) GpiQueryCp (HPS hps);
BOOL __attribute__((__system__)) GpiQueryCurrentPosition (HPS hps, PPOINTL pptlPoint);
BOOL __attribute__((__system__)) GpiQueryDefArcParams (HPS hps, PARCPARAMS parcpArcParams);
BOOL __attribute__((__system__)) GpiQueryDefAttrs (HPS hps, LONG lPrimType, ULONG flAttrMask,
    PBUNDLE ppbunAttrs);
BOOL __attribute__((__system__)) GpiQueryDefCharBox (HPS hps, PSIZEL psizlSize);
BOOL __attribute__((__system__)) GpiQueryDefTag (HPS hps, PLONG plTag);
BOOL __attribute__((__system__)) GpiQueryDefViewingLimits (HPS hps, PRECTL prclLimits);
BOOL __attribute__((__system__)) GpiQueryDefaultViewMatrix (HPS hps, LONG lCount, PMATRIXLF pmatlfArray);
LONG __attribute__((__system__)) GpiQueryEditMode (HPS hps);
LONG __attribute__((__system__)) GpiQueryElement (HPS hps, LONG lOff, LONG lMaxLength, PBYTE pbData);
LONG __attribute__((__system__)) GpiQueryElementPointer (HPS hps);
LONG __attribute__((__system__)) GpiQueryElementType (HPS hps, PLONG plType, LONG lLength, PSZ pszData);
ULONG __attribute__((__system__)) GpiQueryFaceString (HPS PS, PCSZ FamilyName, PFACENAMEDESC attrs,
    LONG length, PSZ CompoundFaceName);
ULONG __attribute__((__system__)) GpiQueryFontAction (HAB anchor, ULONG options);
LONG __attribute__((__system__)) GpiQueryFontFileDescriptions (HAB hab, PCSZ pszFilename, PLONG plCount,
    PFFDESCS affdescsNames);
BOOL __attribute__((__system__)) GpiQueryFontMetrics (HPS hps, LONG lMetricsLength,
    PFONTMETRICS pfmMetrics);
LONG __attribute__((__system__)) GpiQueryFonts (HPS hps, ULONG flOptions, PCSZ pszFacename,
    PLONG plReqFonts, LONG lMetricsLength, PFONTMETRICS afmMetrics);
LONG __attribute__((__system__)) GpiQueryFullFontFileDescs (HAB hab, PCSZ pszFilename, PLONG plCount,
    PVOID pNames, PLONG plNamesBuffLength);
BOOL __attribute__((__system__)) GpiQueryGraphicsField (HPS hps, PRECTL prclField);
LONG __attribute__((__system__)) GpiQueryKerningPairs (HPS hps, LONG lCount, PKERNINGPAIRS akrnprData);
LONG __attribute__((__system__)) GpiQueryLineEnd (HPS hps);
LONG __attribute__((__system__)) GpiQueryLineJoin (HPS hps);
LONG __attribute__((__system__)) GpiQueryLineType (HPS hps);
FIXED __attribute__((__system__)) GpiQueryLineWidth (HPS hps);
LONG __attribute__((__system__)) GpiQueryLineWidthGeom (HPS hps);
LONG __attribute__((__system__)) GpiQueryLogColorTable (HPS hps, ULONG flOptions, LONG lStart, LONG lCount,
    PLONG alArray);
BOOL __attribute__((__system__)) GpiQueryLogicalFont (HPS PS, LONG lcid, PSTR8 name, PFATTRS attrs,
    LONG length);
LONG __attribute__((__system__)) GpiQueryMarker (HPS hps);
BOOL __attribute__((__system__)) GpiQueryMarkerBox (HPS hps, PSIZEF psizfxSize);
LONG __attribute__((__system__)) GpiQueryMarkerSet (HPS hps);
BOOL __attribute__((__system__)) GpiQueryMetaFileBits (HMF hmf, LONG lOffset, LONG lLength, PBYTE pbData);
LONG __attribute__((__system__)) GpiQueryMetaFileLength (HMF hmf);
LONG __attribute__((__system__)) GpiQueryMix (HPS hps);
BOOL __attribute__((__system__)) GpiQueryModelTransformMatrix (HPS hps, LONG lCount,
    PMATRIXLF pmatlfArray);
LONG __attribute__((__system__)) GpiQueryNearestColor (HPS hps, ULONG flOptions, LONG lRgbIn);
LONG __attribute__((__system__)) GpiQueryNearestPaletteIndex(HPAL hpal, ULONG ulColor);
LONG __attribute__((__system__)) GpiQueryNumberSetIds (HPS hps);
BOOL __attribute__((__system__)) GpiQueryPageViewport (HPS hps, PRECTL prclViewport);
HPAL __attribute__((__system__)) GpiQueryPalette (HPS hps);
LONG __attribute__((__system__)) GpiQueryPaletteInfo (HPAL hpal, HPS hps, ULONG flOptions,
    ULONG ulStart, ULONG ulCount, PULONG aulArray);
LONG __attribute__((__system__)) GpiQueryPattern (HPS hps);
BOOL __attribute__((__system__)) GpiQueryPatternRefPoint (HPS hps, PPOINTL pptlRefPoint);
LONG __attribute__((__system__)) GpiQueryPatternSet (HPS hps);
LONG __attribute__((__system__)) GpiQueryRealColors (HPS hps, ULONG flOptions, LONG lStart, LONG lCount,
    PLONG alColors);
LONG __attribute__((__system__)) GpiQueryRegionBox (HPS hps, HRGN hrgn, PRECTL prclBound);
BOOL __attribute__((__system__)) GpiQueryRegionRects (HPS hps, HRGN hrgn, PRECTL prclBound,
    PRGNRECT prgnrcControl, PRECTL prclRect);
LONG __attribute__((__system__)) GpiQueryRGBColor (HPS hps, ULONG flOptions, LONG lColorIndex);
BOOL __attribute__((__system__)) GpiQuerySegmentTransformMatrix (HPS hps, LONG lSegid, LONG lCount,
    PMATRIXLF pmatlfArray);
BOOL __attribute__((__system__)) GpiQuerySetIds (HPS hps, LONG lCount, PLONG alTypes, PSTR8 aNames,
    PLONG allcids);
BOOL __attribute__((__system__)) GpiQueryTextAlignment (HPS hps, PLONG plHoriz, PLONG plVert);
BOOL __attribute__((__system__)) GpiQueryTextBox (HPS hps, LONG lCount1, PCH pchString, LONG lCount2,
    PPOINTL aptlPoints);
BOOL __attribute__((__system__)) GpiQueryViewingLimits (HPS hps, PRECTL prclLimits);
BOOL __attribute__((__system__)) GpiQueryViewingTransformMatrix (HPS hps, LONG lCount,
    PMATRIXLF pmatlfArray);
BOOL __attribute__((__system__)) GpiQueryWidthTable (HPS hps, LONG lFirstChar, LONG lCount, PLONG alData);
LONG __attribute__((__system__)) GpiRectInRegion (HPS hps, HRGN hrgn, __const__ RECTL *prclRect);
LONG __attribute__((__system__)) GpiRectVisible (HPS hps, __const__ RECTL *prclRectangle);
ULONG __attribute__((__system__)) GpiResizePalette(HPAL hpal, ULONG ulNewSize);
BOOL __attribute__((__system__)) GpiRotate (HPS hps, PMATRIXLF pmatlfArray, LONG lOptions, FIXED fxAngle,
    __const__ POINTL *pptlCenter);
BOOL __attribute__((__system__)) GpiSaveMetaFile (HMF hmf, PCSZ pszFilename);
BOOL __attribute__((__system__)) GpiScale (HPS hps, PMATRIXLF pmfatlfArray, LONG lOptions,
    __const__ FIXED *afxScale, __const__ POINTL *pptlCenter);
HPAL __attribute__((__system__)) GpiSelectPalette (HPS hps, HPAL hpal);
BOOL __attribute__((__system__)) GpiSetArcParams (HPS hps, __const__ ARCPARAMS *parcpArcParams);
BOOL __attribute__((__system__)) GpiSetAttrMode (HPS hps, LONG lMode);
BOOL __attribute__((__system__)) GpiSetAttrs (HPS hps, LONG lPrimType, ULONG flAttrMask, ULONG flDefMask,
    __const__ void *ppbunAttrs);
BOOL __attribute__((__system__)) GpiSetBackColor (HPS hps, LONG lColor);
BOOL __attribute__((__system__)) GpiSetBackMix (HPS hps, LONG lMixMode);
BOOL __attribute__((__system__)) GpiSetCharAngle (HPS hps, __const__ GRADIENTL *pgradlAngle);
BOOL __attribute__((__system__)) GpiSetCharBox (HPS hps, __const__ SIZEF *psizfxBox);
BOOL __attribute__((__system__)) GpiSetCharBreakExtra (HPS hps, FIXED BreakExtra);
BOOL __attribute__((__system__)) GpiSetCharDirection (HPS hps, LONG lDirection);
BOOL __attribute__((__system__)) GpiSetCharExtra (HPS hps, FIXED Extra);
BOOL __attribute__((__system__)) GpiSetCharMode (HPS hps, LONG lMode);
BOOL __attribute__((__system__)) GpiSetCharSet (HPS hps, LONG llcid);
BOOL __attribute__((__system__)) GpiSetCharShear (HPS hps, __const__ POINTL *pptlAngle);
BOOL __attribute__((__system__)) GpiSetClipPath (HPS hps, LONG lPath, LONG lOptions);
LONG __attribute__((__system__)) GpiSetClipRegion (HPS hps, HRGN hrgn, PHRGN phrgnOld);
BOOL __attribute__((__system__)) GpiSetColor (HPS hps, LONG lColor);
BOOL __attribute__((__system__)) GpiSetCp (HPS hps, ULONG ulCodePage);
BOOL __attribute__((__system__)) GpiSetCurrentPosition (HPS hps, __const__ POINTL *pptlPoint);
BOOL __attribute__((__system__)) GpiSetDefArcParams (HPS hps, __const__ ARCPARAMS *parcpArcParams);
BOOL __attribute__((__system__)) GpiSetDefAttrs (HPS hps, LONG lPrimType, ULONG flAttrMask,
    __const__ void *ppbunAttrs);
BOOL __attribute__((__system__)) GpiSetDefaultViewMatrix (HPS hps, LONG lCount,
    __const__ MATRIXLF *pmatlfarray, LONG lOptions);
BOOL __attribute__((__system__)) GpiSetDefTag (HPS hps, LONG lTag);
BOOL __attribute__((__system__)) GpiSetDefViewingLimits (HPS hps, __const__ RECTL *prclLimits);
BOOL __attribute__((__system__)) GpiSetEditMode (HPS hps, LONG lMode);
BOOL __attribute__((__system__)) GpiSetElementPointer (HPS hps, LONG lElement);
BOOL __attribute__((__system__)) GpiSetElementPointerAtLabel (HPS hps, LONG lLabel);
BOOL __attribute__((__system__)) GpiSetGraphicsField (HPS hps, __const__ RECTL *prclField);
BOOL __attribute__((__system__)) GpiSetLineEnd (HPS hps, LONG lLineEnd);
BOOL __attribute__((__system__)) GpiSetLineJoin (HPS hps, LONG lLineJoin);
BOOL __attribute__((__system__)) GpiSetLineType (HPS hps, LONG lLineType);
BOOL __attribute__((__system__)) GpiSetLineWidth (HPS hps, FIXED fxLineWidth);
BOOL __attribute__((__system__)) GpiSetLineWidthGeom (HPS hps, LONG lLineWidth);
BOOL __attribute__((__system__)) GpiSetMarker (HPS hps, LONG lSymbol);
BOOL __attribute__((__system__)) GpiSetMarkerBox (HPS hps, __const__ SIZEF *psizfxSize);
BOOL __attribute__((__system__)) GpiSetMarkerSet (HPS hps, LONG lSet);
BOOL __attribute__((__system__)) GpiSetMetaFileBits (HMF hmf, LONG lOffset, LONG lLength,
    __const__ BYTE *pbBuffer);
BOOL __attribute__((__system__)) GpiSetMix (HPS hps, LONG lMixMode);
BOOL __attribute__((__system__)) GpiSetModelTransformMatrix (HPS hps, LONG lCount,
    __const__ MATRIXLF *pmatlfArray, LONG lOptions);
BOOL __attribute__((__system__)) GpiSetPageViewport (HPS hps, __const__ RECTL *prclViewport);
BOOL __attribute__((__system__)) GpiSetPaletteEntries (HPAL hpal, ULONG ulFormat, ULONG ulStart,
    ULONG ulCount, __const__ ULONG *aulTable);
BOOL __attribute__((__system__)) GpiSetPattern (HPS hps, LONG lPatternSymbol);
BOOL __attribute__((__system__)) GpiSetPatternRefPoint (HPS hps, __const__ POINTL *pptlRefPoint);
BOOL __attribute__((__system__)) GpiSetPatternSet (HPS hps, LONG lSet);
BOOL __attribute__((__system__)) GpiSetRegion (HPS hps, HRGN hrgn, LONG lcount,
    __const__ RECTL *arclRectangles);
BOOL __attribute__((__system__)) GpiSetSegmentTransformMatrix (HPS hps, LONG lSegid, LONG lCount,
    __const__ MATRIXLF *pmatlfarray, LONG lOptions);
BOOL __attribute__((__system__)) GpiSetTextAlignment (HPS hps, LONG lHoriz, LONG lVert);
BOOL __attribute__((__system__)) GpiSetViewingLimits (HPS hps, __const__ RECTL *prclLimits);
BOOL __attribute__((__system__)) GpiSetViewingTransformMatrix (HPS hps, LONG lCount,
    __const__ MATRIXLF *pmatlfArray, LONG lOptions);
LONG __attribute__((__system__)) GpiStrokePath (HPS hps, LONG lPath, ULONG flOptions);
BOOL __attribute__((__system__)) GpiTranslate (HPS hps, PMATRIXLF pmatlfArray, LONG lOptions,
    __const__ POINTL *pptlTranslation);
BOOL __attribute__((__system__)) GpiUnloadFonts (HAB hab, PCSZ pszFilename);
BOOL __attribute__((__system__)) GpiUnloadPublicFonts (HAB hab, PCSZ pszFilename);
# 9316 "/@unixroot/usr/include/os2emx.h" 3 4
LONG __attribute__((__system__)) GpiBitBlt (HPS hpsTarget, HPS hpsSource, LONG lCount,
    __const__ POINTL *aptlPoints, LONG lRop, ULONG flOptions);
BOOL __attribute__((__system__)) GpiDeleteBitmap (HBITMAP hbm);
HBITMAP __attribute__((__system__)) GpiLoadBitmap (HPS hps, HMODULE Resource, ULONG idBitmap,
    LONG lWidth, LONG lHeight);
HBITMAP __attribute__((__system__)) GpiSetBitmap (HPS hps, HBITMAP hbm);
LONG __attribute__((__system__)) GpiWCBitBlt (HPS hpsTarget, HBITMAP hbmSource, LONG lCount,
    __const__ POINTL *aptlPoints, LONG lRop, ULONG flOptions);
# 9549 "/@unixroot/usr/include/os2emx.h" 3 4
BOOL __attribute__((__system__)) GpiAssociate (HPS hps, HDC hdc);
HPS __attribute__((__system__)) GpiCreatePS (HAB hab, HDC hdc, PSIZEL psizlSize, ULONG flOptions);
BOOL __attribute__((__system__)) GpiDestroyPS (HPS hps);
BOOL __attribute__((__system__)) GpiErase (HPS hps);
HDC __attribute__((__system__)) GpiQueryDevice (HPS hps);
BOOL __attribute__((__system__)) GpiRestorePS (HPS hps, LONG lPSid);
LONG __attribute__((__system__)) GpiSavePS (HPS hps);
# 9894 "/@unixroot/usr/include/os2emx.h" 3 4
typedef PSZ *PDEVOPENDATA;


typedef struct _DRIVDATA
{
  LONG cb;
  LONG lVersion;
  CHAR szDeviceName[32];
  CHAR abGeneralData[1];
} DRIVDATA;
typedef DRIVDATA *PDRIVDATA;

typedef struct _DEVOPENSTRUC
{
  PSZ pszLogAddress;
  PSZ pszDriverName;
  PDRIVDATA pdriv;
  PSZ pszDataType;
  PSZ pszComment;
  PSZ pszQueueProcName;
  PSZ pszQueueProcParams;
  PSZ pszSpoolerParams;
  PSZ pszNetworkParams;
} DEVOPENSTRUC;
typedef DEVOPENSTRUC *PDEVOPENSTRUC;

typedef struct _ESCMODE
{
  ULONG mode;
  BYTE modedata[1];
} ESCMODE;
typedef ESCMODE *PESCMODE;

typedef struct _VIOSIZECOUNT
{
  LONG maxcount;
  LONG count;
} VIOSIZECOUNT;
typedef VIOSIZECOUNT *PVIOSIZECOUNT;

typedef struct _VIOFONTCELLSIZE
{
  LONG cx;
  LONG cy;
} VIOFONTCELLSIZE;
typedef VIOFONTCELLSIZE *PVIOFONTCELLSIZE;

typedef struct _SFACTORS
{
  LONG x;
  LONG y;
} SFACTORS;
typedef SFACTORS *PSFACTORS;

typedef struct _BANDRECT
{
  LONG xleft;
  LONG ybottom;
  LONG xright;
  LONG ytop;
} BANDRECT;
typedef BANDRECT *PBANDRECT;

typedef struct _HCINFO
{
  CHAR szFormname[32];
  LONG cx;
  LONG cy;
  LONG xLeftClip;
  LONG yBottomClip;
  LONG xRightClip;
  LONG yTopClip;
  LONG xPels;
  LONG yPels;
  LONG flAttributes;
} HCINFO;
typedef HCINFO *PHCINFO;

HMF __attribute__((__system__)) DevCloseDC (HDC hdc);
LONG __attribute__((__system__)) DevEscape (HDC hdc, LONG lCode, LONG lInCount, PBYTE pbInData,
    PLONG plOutCount, PBYTE pbOutData);
HDC __attribute__((__system__)) DevOpenDC (HAB hab, LONG lType, PCSZ pszToken, LONG lCount,
    PDEVOPENDATA pdopData, HDC hdcComp);
LONG __attribute__((__system__)) DevPostDeviceModes (HAB hab, PDRIVDATA pdrivDriverData ,
    PCSZ pszDriverName, PCSZ pszDeviceName, PCSZ pszName, ULONG flOptions);
BOOL __attribute__((__system__)) DevQueryCaps (HDC hdc, LONG lStart, LONG lCount, PLONG alArray);
BOOL __attribute__((__system__)) DevQueryDeviceNames (HAB hab, PCSZ pszDriverName, PLONG pldn,
    PSTR32 aDeviceName, PSTR64 aDeviceDesc, PLONG pldt, PSTR16 aDataType);
LONG __attribute__((__system__)) DevQueryHardcopyCaps (HDC hdc, LONG lStartForm, LONG lForms,
    PHCINFO phciHcInfo);
# 9995 "/@unixroot/usr/include/os2emx.h" 3 4
typedef LHANDLE HSWITCH;
typedef HSWITCH *PHSWITCH;

typedef LHANDLE HPROGRAM;
typedef HPROGRAM *PHPROGRAM;

typedef LHANDLE HINI;
typedef HINI *PHINI;

typedef LHANDLE HAPP;


typedef struct _PRFPROFILE
{
  ULONG cchUserName;
  PSZ pszUserName;
  ULONG cchSysName;
  PSZ pszSysName;
} PRFPROFILE;
typedef PRFPROFILE *PPRFPROFILE;
# 10134 "/@unixroot/usr/include/os2emx.h" 3 4
typedef struct _SWCNTRL
{
  HWND hwnd;
  HWND hwndIcon;
  HPROGRAM hprog;
  PID idProcess;
  ULONG idSession;
  ULONG uchVisibility;
  ULONG fbJump;
  CHAR szSwtitle[60 +4];
  ULONG bProgType;
} SWCNTRL;
typedef SWCNTRL *PSWCNTRL;

HSWITCH __attribute__((__system__)) WinAddSwitchEntry (__const__ SWCNTRL *pswctl);
ULONG __attribute__((__system__)) WinRemoveSwitchEntry (HSWITCH hsw);
# 11686 "/@unixroot/usr/include/os2emx.h" 3 4
typedef struct _OBJCLASS
{
  struct _OBJCLASS *pNext;
  PSZ pszClassName;
  PSZ pszModName;
} OBJCLASS;
typedef OBJCLASS *POBJCLASS;

HOBJECT __attribute__((__system__)) WinCopyObject (HOBJECT hObjectofObject, HOBJECT hObjectofDest,
    ULONG ulReserved);
HOBJECT __attribute__((__system__)) WinCreateObject (PCSZ pszClassName, PCSZ pszTitle, PCSZ pszSetupString,
    PCSZ pszLocation, ULONG ulFlags);
HOBJECT __attribute__((__system__)) WinCreateShadow (HOBJECT hObjectofObject, HOBJECT hObjectofDest,
    ULONG ulReserved);
BOOL __attribute__((__system__)) WinDeregisterObjectClass (PCSZ pszClassName);
BOOL __attribute__((__system__)) WinDestroyObject (HOBJECT hObject);
BOOL __attribute__((__system__)) WinEnumObjectClasses (POBJCLASS pObjClass, PULONG pulSize);
BOOL __attribute__((__system__)) WinIsSOMDDReady (void);
BOOL __attribute__((__system__)) WinIsWPDServerReady (void);
HOBJECT __attribute__((__system__)) WinMoveObject (HOBJECT hObjectofObject, HOBJECT hObjectofDest,
    ULONG ulReserved);
BOOL __attribute__((__system__)) WinOpenObject (HOBJECT hObject, ULONG ulView, BOOL fFlag);
BOOL __attribute__((__system__)) WinQueryActiveDesktopPathname (PSZ pszPathName, ULONG ulSize);
HOBJECT __attribute__((__system__)) WinQueryObject (PCSZ pszObjectID);
BOOL __attribute__((__system__)) WinQueryObjectPath (HOBJECT hobject, PSZ pszPathName, ULONG ulSize);
BOOL __attribute__((__system__)) WinRegisterObjectClass (PCSZ pszClassName, PCSZ pszModName);
BOOL __attribute__((__system__)) WinReplaceObjectClass (PCSZ pszOldClassName, PCSZ pszNewClassName,
    BOOL fReplace);
ULONG __attribute__((__system__)) WinRestartSOMDD (BOOL fState);
ULONG __attribute__((__system__)) WinRestartWPDServer (BOOL fState);
BOOL __attribute__((__system__)) WinSaveObject (HOBJECT hObject, BOOL fAsync);
BOOL __attribute__((__system__)) WinSetObjectData (HOBJECT hObject, PCSZ pszSetupString);





BOOL __attribute__((__system__)) WinFreeFileIcon (HPOINTER hptr);
HPOINTER __attribute__((__system__)) WinLoadFileIcon (PCSZ pszFileName, BOOL fPrivate);
BOOL __attribute__((__system__)) WinRestoreWindowPos (PCSZ pszAppName, PCSZ pszKeyName, HWND hwnd);



BOOL __attribute__((__system__)) WinShutdownSystem (HAB hab, HMQ hmq);
BOOL __attribute__((__system__)) WinStoreWindowPos (PCSZ pszAppName, PCSZ pszKeyName, HWND hwnd);
# 13628 "/@unixroot/usr/include/os2emx.h" 3 4
#pragma pack()
# 36 "/@unixroot/usr/include/os2.h" 2 3 4

# 1 "/@unixroot/usr/include/os2thunk.h" 1 3 4
# 9 "/@unixroot/usr/include/os2thunk.h" 3 4
# 1 "/@unixroot/usr/include/sys/cdefs.h" 1 3 4
# 627 "/@unixroot/usr/include/sys/cdefs.h" 3 4
# 1 "/@unixroot/usr/include/sys/gnu/cdefs.h" 1 3 4
# 30 "/@unixroot/usr/include/sys/gnu/cdefs.h" 3 4
# 1 "/@unixroot/usr/include/features.h" 1 3 4
# 31 "/@unixroot/usr/include/sys/gnu/cdefs.h" 2 3 4
# 628 "/@unixroot/usr/include/sys/cdefs.h" 2 3 4
# 10 "/@unixroot/usr/include/os2thunk.h" 2 3 4



typedef unsigned long _far16ptr;

_far16ptr _libc_32to16 (void *ptr);
void *_libc_16to32 (_far16ptr ptr);

typedef union _thunk_u
{
    void *pv;
    unsigned short *pus;
    unsigned long *pul;
} _thunk_t;

unsigned long _libc_thunk1 (void *args, void *fun);
# 77 "/@unixroot/usr/include/os2thunk.h" 3 4

# 38 "/@unixroot/usr/include/os2.h" 2 3 4
# 5 "indirect5.c" 2






int main(int argc,char *argv[]) {
  APIRET rc; ULONG cbWritten; int len;







  argc = argc +1;
  argv = 66;

  return 33;

}
