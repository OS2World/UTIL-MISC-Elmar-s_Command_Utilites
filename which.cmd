/* which for BASH and CMD under OS/2 */
call RxFuncAdd SysLoadFuncs,RexxUtil,SysLoadFuncs
call SysLoadFuncs

/* this is the correct execution order under bash; however not under cmd: */
/* search for *.exe on all paths first; then for *.cmd etc. */
/* search for *.exe, *, *.cmd in this direction */

/* parse source os what me */
/* alway OS/2 COMMAND me -> also when invoked from bash */
/* isbash = value('BASH',,'OS2ENVIRONMENT');  would need to export this environment variable */

parse arg args
if Pos("-help",args)>0 THEN call help
.local~avlopts='--all --os2 --help';
.local~args=args;
call PrepareAvlOpts;
call ParseOpts;
IF .local~wasbadopt THEN exit
opts=.local~opts;
IF in('h',opts) THEN call help
call SplitArgs;
args.=.local~argary;
lf='0D0A'x;

isbash = \ ( Pos('o',opts) > 0 );
reportall = ( Pos('a',opts) > 0 );

DO i=1 TO args.0

  IF isbash THEN DO
    which = SysSearchPath('PATH',args.i||".com")
    call combine SysSearchPath('PATH',args.i||".exe")
    call combine SysSearchPath('PATH',args.i)
    call combine SysSearchPath('PATH',args.i||".cmd")
    which = translate(which,'/','\')

  END; ELSE DO
    /* not correct: would need to search dir by dir. */
    paths = translate( value('PATH',,'OS2ENVIRONMENT'), ' ;', '; ' );
    DO j=1 TO words(paths)
      thisPATH = translate( word(paths,j), ' ;', '; ' );
      which = SysSearchPath('thisPATH',args.i||".com")
      call combine SysSearchPath('thisPATH',args.i||".exe")
      call combine SysSearchPath('thisPATH',args.i||".cmd")
      call combine SysSearchPath('thisPATH',args.i||".bat")
    END;

  END;
  /* bare executables: only executable under bash; not under cmd.exe */
  /* *.bat not executable  under bash */

  say which

END;
exit;

combine:
  IF \ reportall THEN DO
    IF which = "" THEN which = ARG(1);
  END; ELSE DO
    IF ARG(1)\="" THEN DO
      IF which="" THEN which=ARG(1); ELSE which=which||lf||ARG(1); END;
  END;
return

help:
  parse source os what me
  say filespec('name',me) ' executable'
  say ' -a/--all ... view all executables on path'
  say ' -o/--os2 ... check for cmd.exe instead of bash'
exit 0;

::requires common.rlb



