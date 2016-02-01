/* which for OS/2 */
call RxFuncAdd SysLoadFuncs,RexxUtil,SysLoadFuncs
call SysLoadFuncs

parse arg args
if Pos("-help",args)>0 THEN call help
.local~avlopts='--files --dirs --both x n --absolute s h r a S H R A q Q u e c z y';
.local~args=args;
call PrepareAvlOpts;
call ParseOpts;
IF .local~wasbadopt THEN exit
opts=.local~opts;
call SplitArgs;
args.=.local~argary;

findopt='B'; extsplit=0;
prefix='.\'
IF Pos('u',opts)>0 THEN DO; unix=1; prefix='./'; END; ELSE unix=0;
IF Pos('f',opts)>0 THEN findopt='F'
IF Pos('d',opts)>0 THEN findopt='D'
IF ( Pos('f',opts)>0 & Pos('d',opts)>0 ) | Pos('b',opts)>0 THEN findopt='B'
IF Pos('e',opts)>0 THEN abspath=1; ELSE abspath=0;
frontattr=1;
IF Pos('x',opts)>0 THEN extsplit=1; 
IF Pos('y',opts)>0 THEN DO; extsplit=2; frontattr=0; END;
IF Pos('z',opts)>0 THEN DO; extsplit=1; frontattr=0; END;
IF extsplit=0 THEN findopt=findopt||'O';

IF Pos('n',opts)>0 THEN prefix=''
/*IF Pos('h',opts)>0 THEN call Help*/
/* -xn parse from column 35 on: filename */

attrlis="a-hrs"
attrs="*****"
DO i=1 TO 5; chk=0;
  IF substr(attrlis,i,1)\='-' THEN DO
    IF Pos(substr(attrlis,i,1),opts)>0 THEN DO; attrs=overlay('+',attrs,i,1); chk=chk+1; END;
    IF Pos(translate(substr(attrlis,i,1)),opts)>0 THEN DO; attrs=overlay('-',attrs,i,1); chk=chk+1; END;
    IF chk>=2 THEN attrs=overlay('*',attrs,i,1);
  END;
END;

attrlis="-qh-s"
dirattrs="*****"
DO i=1 TO 5;
  a = translate(substr(attrlis,i,1));
  IF a\='-' & Pos(a,opts)>0 THEN dirattrs=overlay('-',dirattrs,i,1);
END;

phyactdir=directory(); 
IF Pos('c',opts)>0 THEN DO
  IF args.0 \= 1 THEN DO; Say 'error: -c option may only be used with a single directory'; exit 1; END;
  phyactdir=args.1;
END;
IF right(phyactdir,1)\='\' THEN phyactdir=phyactdir||'\'

DO i=1 TO args.0;
  actdir=translate(phyactdir); actarg=translate(args.i);
  IF Pos('c',opts)<=0 & ( actdir==actarg | actdir==actarg||'\' ) THEN actdir='NUL:';
  call Main translate(args.i,'\','/')  /* translate(arg,out,in) */
END;
IF args.0<=0 THEN call Main "."
exit

Main:
  push i; push subdirs.0;
  /* not restored: subdirs.*, thissearch */
  parse arg thissearch;
    IF thissearch=='' THEN thissearch='.'
    if \ FileExists(thissearch) & right(thissearch,1)\='\' then thissearch=thissearch||'\'
    /*say '>>' thissearch*/
    call SysFileTree thissearch, files, findopt, attrs;
    DO i=1 TO files.0;
      IF extsplit>0     /* split e<x>tended directory listing */
        THEN DO; actfile=substr(files.i,38); actattr=left(files.i,37); IF extsplit==2 THEN actattr=substr(actattr,17,12); END;
        ELSE DO; actfile=files.i; actattr=''; END;
      IF \abspath & translate(substr(actfile,1,length(actdir)))==actdir
        THEN actfile=prefix||substr(actfile,length(actdir)+1);
      IF unix THEN actfile=translate(actfile,'/','\')
      IF frontattr THEN say actattr||actfile; ELSE say actfile||' :: '||actattr;
    END;
    call SysFileTree thissearch, subdirs, 'DO', dirattrs;
    DO i=1 TO subdirs.0; push subdirs.i; END;
    DO i=1 TO subdirs.0
      parse pull actsubdir
      call Main actsubdir
    END;
  pull subdirs.0; pull i;
return


Help:
  parse source os what me; me=filespec('name',me); me=substr(me,1,LastPos('.',me)-1)
  mepad=copies(' ',length(me))
  say me "--dirs / --files / --both ... show only files/directories"
  say mepad "-xz ... do not only output files but also their attributes (-x: front -z:tail)"
  say mepad "-y ... append size to each file separated by :: "
  say mepad "-n ... do not prefix with .\"
  say mepad "-e ... use absolute (entire) path instead of relative starting with .\"
  say mepad "-aqhrs ... archive, directory, hidden, readonly, system attrs. set"
  say mepad "-AQHRS ... same attrs unset: list files and directories"
  say mepad "-HSQ ... do not descend into a hidden or system dir or any dir"
  say mepad "-Qd ... list directories in current dir; do not descend"
  say mepad "-Qf ... list files in current dir; do not descend (-q without effect)"
  say mepad "-u ... unix style directory separators: '/' instead of '\' (swap both chars)."
  say mepad "-c ... output relative to the stated root (as it were the current directory)"
  say
exit


::requires common.rlb


