/* updatedb for OS2 */
/* Elmar Stellnberger 27-12-2012 */

drives = sysdrivemap('C','Used');
datafile = value('UNIXROOT',,'OS2ENVIRONMENT')||'\data\locatedb.txt'
stderr='STDERR:'; lf='0D0A'x

dirname = chop(filespec('drive',datafile)||filespec('path',datafile),'\')
IF \ DirectoryExists(dirname) THEN DO
  rc = SysMkDir(dirname);
  if rc\=0 then do; call charout stderr, 'error 'rc' creating directory 'dirname||lf; exit 3; end;
  say 'created directory 'dirname' ...'
END;

IF FileExists(datafile) THEN DO
  rc = SysFileDelete(datafile);
  if rc\=0 then do; call charout stderr, 'error 'rc' deleting 'datafile||lf; exit 2; end;
  say 'creating new 'datafile' ...'
END; ELSE
  say 'creating 'datafile' for the first time ...'


do i=1 to words(drives)
  parse value SysDriveInfo(word(drives,i)) with drive free capacity label
  IF drive='' THEN iterate
  say 'indexing drive' drive '...'
  'allfiles --both 'drive'\ >>'datafile
end

exit 0;

FileExists:
  call SysFileTree arg(1), files, 'FO'
  return files.0 > 0

DirectoryExists:
  call SysFileTree arg(1), files, 'DO'
  return files.0 > 0

chop:
  IF length(arg(1))>0 & right(arg(1),1)=arg(2)
    THEN return left(arg(1),length(arg(1))-1); 
    ELSE return arg(1);


