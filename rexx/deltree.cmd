/* which for OS/2 */
call RxFuncAdd SysLoadFuncs,RexxUtil,SysLoadFuncs
call SysLoadFuncs

parse arg args
if Pos("-help",args)>0 THEN call help
.local~avlopts='h';
.local~args=args;
call ParseOpts;
IF .local~wasbadopt THEN exit
opts=.local~opts;
call SplitArgs;
args.=.local~argary;

if Pos('h',opts)>0 THEN call help

DO i=1 TO args.0;
  call Main translate(args.i,'\','/')  /* translate(arg,out,in) */
END;
IF args.0<=0 THEN call Main "."
exit


::routine Main
  push i; push subdirs.0;
  /* not restored: subdirs.*, thissearch */
  parse arg thisdelte;
    IF thisdelete=='' THEN return 1; /* error message */
    IF FileExists(thisdelete) THEN DO
      say 'delete ' thisdelete;
      return 0;
    END;
    IF right(thisdelete,1)\='\' then thisdelete=thisdelete||'\'
    /*say '>>' thissearch*/
    call SysFileTree thisdelete, subdirs, 'DO', dirattrs;
    DO i=1 TO subdirs.0
      call Main subdirs.i
    END;
    call SysFileTree thisdelete, files, 'FO', attrs;
    DO i=1 TO files.0;
      say 'delete ' files.i;
    END;
  pull subdirs.0; pull i;
return


Help:
  parse source os what me; me=filespec('name',me); me=substr(me,1,LastPos('.',me)-1)
  mepad=copies(' ',length(me))
  say me "dir1 dir2 dir3 ... delete directory tree."
  say
exit


::requires common.rlb


