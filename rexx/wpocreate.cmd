/* create workplace shell object */

parse arg handle wpclass dir name
parse arg param1 otherparams

IF param1="-h" | param1="--help" | param1="-help" THEN DO
  parse source os what me
  say filespec('name',me) '"<objecthandle>" class "directory" "description"'
  say ' instantiates (creates) a workplace shell object fromout of a given class'
  say ' get a list of classes: wpclist / list handles of existing objects with wpolist'
  say ' example: wpocreate <WPScrollMouse> WPDevMouse ScrollPoint Mouse Configuration'
  say ' tip: you can use the handle as file name; don`t prepend any directory'
  say '      wp shell object`s don`t have any: they are stored in your .ini - files'
  say ' directory=. for use of current dir '
  say
  exit 0;
END;

parse arg args
.local~args = args
call SplitArgs; args.=.local~argary; nargs=args.0;
handle = args.1; wpclass = args.2; dir = args.3; name = args.4;

IF nargs\=4 | wpclass="" | name="" THEN DO; parse source os what me
  say filespec('name',me) '"<objecthandle>" class directory "description"'; exit 0; END;

IF left(handle,1)\='<' | right(handle,1)\='>' | length(handle)<3 THEN DO
  Say '<objecthandle> (1.st param) needs to be enclosed in <,>-brackets;';
  Say ' don`t forget the quotes "<..>"; see -h.'; exit 1; END;

IF \ DirectoryExists(dir) THEN DO; Say 'directory "'dir'" not found.'; exit 2; END;

Setup = 'OBJECTID='handle';' 
IF dir="" THEN dir="."

say wpclass
say name
say dir 
say setup
exit
rc = SysCreateObject(wpclass, name, dir, Setup )
IF rc=0 THEN say "error creating object."; 

::requires common.rlb

