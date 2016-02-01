/* Apache 2 get */
rc = RxFuncAdd('SockLoadFuncs','rxsock','SockLoadFuncs')
rc = SockLoadFuncs(1);

'@echo off'

parse arg page all
parse value SysTextScreenSize() with rows cols

ps=Pos('/',page); IF ps<=0 THEN ps=length(page)+1;
hostname=left(page,ps-1);
page=substr(page,ps);
IF hostname='' THEN hostname='www.elstel.org'
IF page='' THEN page='/index-aktionen.html.de'

IF SockGetHostByName(hostname,'host.') \= 1 THEN DO
  say 'could not resolve host name.'
  exit 1;
END;

/*host.addrtype = 'AF_INET'*/
address.family = host.addrtype
address.port = 80
address.addr = host.addr
socket = SockSocket(host.addrtype, 'SOCK_STREAM', 'IPPROTO_TCP')
rc = SockConnect(socket, 'address.')
if rc \=0 then do; say 'could not open connection to' host; exit 1; end;

data=''; datalines=0;
call dataline 'GET' page 'HTTP/1.0';
call dataline 'Host:' hostname
call dataline 'Accept: text/html'
call dataline 'Accept-Charset: utf-8'
call dataline

rc = SockSend(socket,data);
IF rc < 0 THEN DO
  Say 'error on socket';
  exit 2;
END;

len = SockRecv(socket,buf,4096);
SELECT
  when len = 0 then Say 'did not receive any data from ' host;
  when len < 0 then Say 'error on socket.' 
OTHERWISE
  ps=1; call SysCls; say; call charout ,data;
  DO i=1 TO max(rows-4-datalines,6);    
    if \MoreLinesInBuf() THEN LEAVE;
    say left(untab(LineFromBuf()),cols-1);
  END;
END;

rc = SockClose(socket)
exit


LineFromBuf:
  IF ps>length(buf) THEN return '<eof>';
  newps = Pos('0A'x,buf,ps); IF newps<=0 THEN newps=length(buf)+1;
  IF newps>1 & substr(buf,newps-1,1)='0D'x THEN chompchar=1; ELSE chompchar=0;
  line = substr(buf,ps,newps-ps-chompchar);
  ps = newps + 1 ;
return line

MoreLinesInBuf:
return ps<=length(buf);

dataline:
  parse arg line
  data=data||line||'0D0A'x
  datalines=datalines+1;
return

untab:
return translate(arg(1),' ','09'x);

/*::requires common.rlb*/




