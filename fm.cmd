/* FileView - icon view of spec dir */
call RxFuncAdd 'SysLoadFuncs', 'REXXUTIL', 'SysLoadFuncs';
call SysLoadFuncs;

IF arg(1,'E') THEN DO; olddir=directory(); say directory(arg(1)); END;

'start C:\OS2\MDOS\WINOS2\WINFILE.EXE' 

IF arg(1,'E') THEN call directory olddir;


