/* process viewer */
parse arg cmd allargs
IF cmd == 'callme' THEN CALL main allargs; ELSE DO
  parse source os what me
  parse arg allargs
  /* say me */
  '@echo off'
  'cat e:\home\bin\dbg.pstat | 'me' callme' allargs
  'pstat /c | 'me' callme' allargs
END;
exit

ishex:
return Verify(ARG(1),xrange(0,9)||xrange('a','f'))==0

fmt:
return right(x2d(arg(1)),max(arg(2),length(arg(1))),'.')

main:
arg seek

DO FOREVER
 DO i=1 TO 4; line=LineIn()
   IF line \= '' THEN LEAVE
 END; IF line == '' THEN return
 PARSE VAR line pid ppid
 IF ishex(pid) THEN LEAVE
END
psoffs=255; blocked=-1; first=1;

DO UNTIL line=='' 
 isnew=0
 IF substr(line,1,psoffs) \= copies(' ',psoffs) THEN DO
   psoffs = wordindex(line,4)-1; 
   IF psoffs<0 THEN psoffs=255; ELSE isnew=1;
 END
 IF isnew THEN DO
   call PrepareThreadStates
   IF \first THEN call AddProcess; first=0;
   PARSE VAR line pid ppid sid exe tid num pty state
   threads=""; blocked=0;
   call ProcessState(state)
 END; ELSE DO
   PARSE VAR line tid num pty state
   call ProcessState(state)
 END
 DO i=1 TO 4; line=LineIn()
   IF line \= '' THEN LEAVE
 END;
END
call PrepareThreadStates
call AddProcess
return

AddProcess:
  IF words(seek)>0 THEN DO
    dobreak=1; parse upper var exe uexe;
    DO i=1 TO words(seek); IF Pos(word(seek,i),uexe)>0 THEN dobreak=0; END;
    IF dobreak==1 THEN return
  END;
  say fmt(pid,4) fmt(ppid,4) fmt(sid,3) threads exe 
return

PrepareThreadStates:
   IF blocked=-1 THEN DO
     threads=''; return; END
   IF threads='' THEN fringe="-"; ELSE fringe="*";
   IF blocked>0 THEN threads=threads||blocked||"b";
   threads=fringe||threads||fringe
   threads=center(threads,max(6,length(threads)))" "
return

ProcessState:
  state=ARG(1)
  stt = translate(substr(strip(state,'leading'),1,1),'b','B')
  IF stt=='b' THEN blocked=blocked+1; ELSE threads=threads||stt;
return

