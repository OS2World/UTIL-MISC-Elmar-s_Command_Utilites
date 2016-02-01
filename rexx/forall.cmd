/* rxEnqueue: queue lines from stdin */
/* available under GPL, by Elmar Stellnberger*/

parse arg args; execute=args;
'@echo off'
if Pos("-help",args)>0 THEN call help
.local~args=args;

.local~avlopts='--blank --help';
call PrepareAvlOpts;
call ParseOpts;
IF .local~wasbadopt THEN exit
opts=.local~opts;
IF in('h',opts) THEN call help

call SplitArgs;
args.=.local~argary;

DO i=1 TO args.0;
  n=0; lp=1; /* lastpos */
  DO forever
    p = Pos('$A',args.i,lp);
    IF p<=0 THEN leave
    n=n+1; ps.i.n=p; lp=p+1;
  END;
  ps.i.0=n;
END;

DO WHILE lines();
  line = linein();
  IF line\="" | Pos('b',opts)>0 THEN
    DO i=1 TO args.0
      doit = ''; lp=1;
      DO j=1 TO ps.i.0;
        doit=doit||substr( args.i, lp, ps.i.j -1 -lp +1 )||line; lp = ps.i.j + 2;
      END;
      doit=doit||substr(args.i,lp)
      /*IF p>0 THEN doit = substr(doit,1,p-1)||line||substr(doit,p+2)*/
      /*ELSE doit=execute line*/
      doit
    END;
END;

exit

help:
  parse source os what me
  say filespec('name',me) ' "command1" "command2" etc.'
  say ' invoke commands for every line substituting $A by the line read.'
  say ' -b/--blank ... do not ignore blank lines'
exit 0;

::requires common.rlb

