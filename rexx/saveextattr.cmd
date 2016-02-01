/* save extended attributes in a parallel directory hirarchy */
/* overwriting/updating is not supported */
call RxFuncAdd SysLoadFuncs,RexxUtil,SysLoadFuncs
call SysLoadFuncs

stderr='STDERR:'; lf='0D0A'x;

parse arg opt
IF opt='-h' | opt='--help' | opt='' THEN DO
  say "saveextattr X:\ X:\eas"
  exit 0;
END

parse arg drive target

call SysFileTree target, 'targetexists', 'DO';
if targetexists.0 > 0 then do
  say "target directory already exist; exiting."
  exit 1;
end
call SysMkDir target

call SysFileTree drive, 'files', 'FSO'
call SysFileTree drive, 'dirs', 'DSO'
do i=1 to dirs.0
  if substr(dirs.i,2,1)=':' then dirname=substr(dirs.i,3); else dirname=dirs.i;
  if substr(dirname,1,1)="\" then dirname=substr(dirname,2);
  call SysMkDir(target||"\"||dirname)
end

'@echo off'
errors=0
do i=1 to files.0
  if substr(files.i,2,1)=':' then filename=substr(files.i,3); else filename=files.i;
  if substr(filename,1,1)="\" then filename=substr(filename,2);
  doit="eautil" '"'||files.i||'"' '"'||target||"\"||filename||".EA"||'"' "/p" "/s"
  doit
  if rc>0 then do
    call charout stderr, doit||lf
    errors=errors+1
    error.errors=doit
  end
end

say "saved extended attributes"
say
do i=1 to errors
  say error.i
end
say errors " errors encountered".
say

