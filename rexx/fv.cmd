/* FileView - icon view of spec dir */
call RxFuncAdd 'SysLoadFuncs', 'REXXUTIL', 'SysLoadFuncs';
call SysLoadFuncs;

IF arg(1,'E') THEN DO; olddir=directory(); say directory(arg(1)); END;

rc=SysSetObjectData(directory(),'OPEN=ICON');

IF arg(1,'E') THEN call directory olddir;

exit rc
