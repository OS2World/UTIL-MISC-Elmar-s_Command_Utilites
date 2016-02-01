/* rxEnqueue: queue lines from stdin */
/* which for OS/2 */
call RxFuncAdd SysLoadFuncs,RexxUtil,SysLoadFuncs
call SysLoadFuncs

parse arg opt file
IF substr(opt,1,1)\='-' THEN
  parse arg file
parse source os what me

IF opt='-h' | opt='--help' | opt='-help' THEN call HelpCmdLine
IF opt='-man' | opt='--man' THEN man=1; ELSE man=0;

IF file\='' THEN
 inp=file
ELSE inp='STDIN:'

/* otp, lf, stderr, red, nv, compkey1, upkey, downkey */
otp='STDOUT:'; stderr='STDERR:'; lf='0D0A'x
red='1B'x'[0;31m'; nv='1B'x'[0m'; green='1B'x'[0;32m';
  compkey1='E0'x; upkey='H'; downkey='P'; ESCkey='1B'x;
IF os=='UNIX' | os=='LINUX' THEN DO; otp=''; stderr=''; lf='0A'x; red='1B'x'[1;31m'; 
  compkey1='5B'x; upkey='41'x; downkey='42'x; ESCkey='1BB'x
END;

parse value SysTextScreenSize() with rows cols
/*say rows cols*/

maxlines=65535; n=0; lastcolor='';
DO WHILE lines(inp)
  n=n+1; IF n>maxlines THEN LEAVE
  line.n=prepare(linein(inp));
END;
IF n>maxlines THEN DO
  call LineOut stderr, red||"file too long; max" maxlines "lines"||nv||lf
  exit 1;
END;
line.0=n;
call stream inp,'C','CLOSE' 
DO i=n+1 TO n+rows; line.i='<eof>'; END;

IF n=0 | n=1 & line.1='' THEN DO
  call charout stderr, "file empty."lf
  exit 1;
END;

/*searchterm='OFTEXT'*/
call charout '1B'x'[0m';
yv=1; xv=1; call View; myline=1;
num=-1
DO UNTIL ukey=ESCkey | ukey='03'x | ukey='q' | ukey='Q';
  key=SysGetKey('NOECHO'); ukey=translate(key);
  SELECT

    WHEN ukey='K' THEN call cmd 'Up'
    WHEN ukey='J' THEN call cmd 'Down'
    WHEN verify(ukey,xrange('0','9'))=0 THEN DO
	/*keynum = c2d(ukey)-c2d('0');*/
        /*IF num<0 THEN num=keynum; ELSE num=keynum+10*num;*/
        IF num<0 THEN num=ukey; ELSE num=num||ukey;
	/*say num '**' keynum*/
      END;

    WHEN key=compkey1 THEN DO
      key=SysGetKey('NOECHO');
      SELECT
        WHEN key=upkey THEN call cmd 'Up'; 
	WHEN key=downkey THEN call cmd 'Down'
        WHEN key='8D'x THEN call cmd 'Up' 4
        WHEN key='91'x THEN call cmd 'Down' 4
        WHEN key='G' THEN call cmd 'Pos1OfText'
        WHEN key='O' THEN call cmd 'EndOfText'
        WHEN key='I' THEN call cmd 'PgUp'
        WHEN key='Q' THEN call cmd 'PgDown'
        WHEN key='K' THEN call cmd 'ScrollLeft' 1
        WHEN key='M' THEN call cmd 'ScrollRight' 1
        WHEN key='s' THEN call cmd 'ScrollPageLeft'
        WHEN key='t' THEN call cmd 'ScrollPageRight'
      OTHERWISE Say 'comp' c2xc(key);
      END
    END

    WHEN key='00'x THEN DO
      key=SysGetKey('NOECHO');
      SELECT
        WHEN key='98'x THEN call cmd 'Up' 2
        WHEN key='A0'x THEN call cmd 'Down' 2
        WHEN key='9B'x THEN call cmd 'ScrollLeft' 3
        WHEN key='9D'x THEN call cmd 'ScrollRight' 3
      OTHERWISE Say 'comp00:' c2xc(key);
      END
    END

    WHEN key='/' THEN call Search
    WHEN key='n' THEN call SearchNext
    WHEN key='N' THEN call SearchPrev
    WHEN ukey='G' THEN call GotoLine
    WHEN ukey='%' THEN call ShowLineScrollPercentage
    WHEN ukey='H' THEN call Help
    WHEN key=' ' THEN call View

  OTHERWISE Say 'key:' c2xc(key);
  END
END

call charout, '1B'x'[0m'
call SysCls
exit 0

cmd:
  parse arg cmd stdnum args; arg cmd rest
  if stdnum=='' then stdnum=1
  if num<=0 then num=stdnum
  /*call (cmd) args*/
  call name args
  num=-1
return

name:
  signal value cmd

Up:
  searchpos=-1
  yv=max(1, yv-num)
  call View
return

Down:
  searchpos=-1
  yv=min(n-rows*2/3, yv+num)
  call View
return

PgUp:
  searchpos=-1
  yv=max(1, yv-num*rows+1)
  call View
return

PgDown:
  searchpos=-1
  yv=min(n-rows*2/3,  yv+num*rows-1)
  call View
return

Pos1OfText:
  searchpos=-1
  yv=1; call View;
return

EndOfText:
  searchpos=-1
  yv=n-rows+1; call View;
return

ScrollLeft:
  xv=max(1,xv-num); call View; return

ScrollRight:
  xv=xv+num; call View; return

ScrollPageLeft:
  xv=max(1,xv-cols/2); call View; return

ScrollPageRight:
  xv=xv+cols/2; call View; return

c2xc:
  IF arg(1) > '20'x THEN return c2x(arg(1))':'||arg(1)
return c2x(arg(1))

simplein:
  result='';
  DO UNTIL key='0D'x;
    key=SysGetKey('ECHO');
    IF key='0D'x THEN leave;
    IF key='08'x THEN DO; IF length(result)>0 THEN result=left(result,length(result)-1); END;
    ELSE result=result||key;
  END;
  say '***'result'***';
return result;


ShowLineScrollPercentage:
  call CmdLine 'viewing lines 'yv'..'yv+rows-1' out of 'n' lines: '||trunc((yv+rows-1)*100/n)||'%'
return

GotoLine:
  call SysCurPos rows-1,0; call SysCurState 'on'
  call charout ,left('/',cols-1)'0D'x'Goto Line Number: '
  IF inp=='STDIN:' THEN newmyline=translate(simplein());
  ELSE pull newmyline;
  IF newmyline\='' THEN myline=newmyline
  IF myline<1 | myline>n THEN DO; call CmdLine red||'Line beyond end or smaller than 1.'||nv; return; END;
  IF myline>yv+rows-1 | myline<yv THEN yv=myline-rows/2;
  call View;
  call SysCurPos myline-yv,0;
  call charout ,green||substr( line.myline, xv, min(length(line.myline)-xv+1,cols-1) )||nv
return

Search:
  call SysCurPos rows-1,0; call SysCurState 'on'
  call charout ,left('/',cols-1)'0D'x'/'
  IF inp=='STDIN:' THEN newsearchterm=translate(simplein());
  ELSE pull newsearchterm;
  IF newsearchterm\='' THEN searchterm=newsearchterm
  searchpos=-1
  call SearchNext
return

SearchNext:
  IF searchpos=-1 THEN searchpos=yv-1
  p=0; DO y=searchpos+1 TO n+1
    p = Pos(searchterm,translate(line.y))
    IF p>0 THEN leave;
  END
  searchpos=min(y,n+1)
  IF p<=0 THEN DO; call CmdLine red||'not found'||nv; return; END;
  yv = max(1, y - rows/2 );
  IF p-xv<0 | p+length(searchterm)>xv+cols THEN xv=max(1,p-cols/2-length(searchterm))
  call View
  call SysCurPos searchpos-yv, p-xv; call charout ,green||substr(line.searchpos,p,length(searchterm))||nv
return

SearchPrev:
  IF searchpos=-1 THEN searchpos=yv+rows-1
  p=0; y=searchpos-1; DO WHILE y>=1
    p = Pos(searchterm,translate(line.y))
    IF p>0 THEN leave;
    y=y-1
  END
  searchpos=max(y,1)
  IF p<=0 THEN DO; call CmdLine red||'not found'||nv; return; END;
  yv = max(1, y - rows/2 );
  IF p-xv<0 | p+length(searchterm)>xv+cols THEN xv=max(1,p-cols/2-length(searchterm))
  call View
  call SysCurPos searchpos-yv, p-xv; call charout ,green||substr(line.searchpos,p,length(searchterm))||nv
return

Help:
  call SysCls;
  say ' less - file viewer'; say
  say ' -/[Alt]/[Ctrl] Left/Right/Up/Down ... move around'
  say ' PgUp, PgDn, Home, End ... page up/down, first/last line'
  say ' [/] searchterm ... search case insensitive without regular expressions'
  say ' [n]/[N] ....... next/prev search result'
  say ' [g] lineno ... goto line number lineno / last entered lineno'
  say ' [%] ... show acutual position in text '
  say ' [space] ... redraw, [1][2][Down] .. 12 lines down'
  say ' [q] ... quit'
  call SysGetKey('NOECHO');
  call View;
return

HelpCmdLine:
  say ' less [--man/--help] file'
  say ' type file | less [--man] '
  say ' ... press [h] to get on screen help while viewing a file.'
exit 0

CmdLine:
  call SysCurPos rows-1,0;
  call charout ,left('/',cols-1)'0D'x||ARG(1)
return  

prepare:
  push j; push c
  result=''; m=1; colors.n.0=1; hl=0;
  colors.n.m.es=lastcolor; colors.n.m.ps=1;
  j=1; DO UNTIL j>length(arg(1))
    c=substr(arg(1),j,1)
    SELECT
      WHEN c=='09'x THEN result=result||'        ';
      WHEN c=='0A'x THEN result=result||'17'x;
      WHEN c=='0D'x THEN result=result||'F4'x;
      WHEN c=='07'x THEN result=result||'0E'x;
      WHEN c=='08'x THEN 
         IF \ man THEN result=result||'11'x;
         ELSE DO
           IF length(result)>0 THEN DO; result=left(result,length(result)-1); nhl=3; END;
           IF hl<=0 & nhl>0 THEN DO
             m=m+1; colors.n.0=m;
             colors.n.m.es='1B'x'[1;37m'
             colors.n.m.ps=length(result)+1;
           END;
           hl=nhl;
         END;
/*      WHEN c < '20'x THEN result=result||'01'x; */
      WHEN c=='1B'x THEN DO
        k=j;
        /* =0 did not work for any reason: error in rexx? */ 
        DO UNTIL verify(c,xrange('a','z')||xrange('A','Z'))<=0 DO
           j=j+1; IF j>length(arg(1)) THEN DO j=j-1; leave; END;
           c=substr(arg(1),j,1)
        END;
        IF c=='m' THEN DO
          m=m+1; colors.n.0=m;
          colors.n.m.es=substr(arg(1),k,j-k+1);
          colors.n.m.ps=length(result)+1;
          lastcolor=colors.n.m.es;
        END;
      END;
      OTHERWISE result=result||c;
     END;
     j=j+1; nhl=max(0,hl-1);
     IF nhl\=hl & nhl=0 & length(result)>1 THEN DO; result2=result; call ManUnHighLight; result=result2; END;
     hl=nhl; /*call charout, hl;*/
  END;
  IF hl>0 THEN DO; result2=result; call ManUnHighLight eol; result=result2; END;
  parse pull c; parse pull j
return result

ManUnHighLight:
  IF length(result)-(1-nhl)+1 <=0 THEN return
  m=m+1; colors.n.0=m;
  colors.n.m.es='1B'x'[0m'
  colors.n.m.ps=length(result)-(1-nhl)+1
  IF arg(1)=="" THEN DO
/*    say unhighlight colors.n.m.ps hl nhl result; pull;*/
  END
return

View:
  call SysCurPos 0,0; call SysCurState 'on';
  DO y=yv TO yv+rows-1
    /*call SysCurPos y-yv,0*/
    IF y==yv+rows-1 THEN thiscols=cols-1; ELSE thiscols=cols;
    /* apply all colors before actual line */
    x=xv;
    k=1; m=colors.y.0; DO WHILE  k<=m & colors.y.k.ps<=xv
      call charout ,colors.y.k.es; k=k+1;
    END;
    /* next colored text chunk */
    DO WHILE k<=m & colors.y.k.ps < xv+thiscols
      call charout ,substr(line.y,x,colors.y.k.ps-x) 
      call charout ,colors.y.k.es;
      x=colors.y.k.ps; k=k+1;
    END;
    /* text at the end of the line */
    call charout ,substr(line.y,x,thiscols-x+xv)
  END
  /*call charout, '0D'x*/
  call charout ,'1B'x'[0m'
return

View1:
  call SysCurPos 0,0; call SysCurState 'on'
  DO y=yv TO yv+rows-1
    /*call SysCurPos y-yv,0*/
    IF y==yv+rows-1 THEN thiscols=cols-1; ELSE thiscols=cols;
    call charout ,substr(line.y,xv,thiscols)
  END
  /*call charout, '0D'x*/
return

View2:
  call SysCls
  DO y=yv TO yv+rows-1
    IF y\=yv THEN call charout ,lf
    call charout ,substr( line.y, xv, min(length(line.y)-xv+1,cols-1) )
  END
return

