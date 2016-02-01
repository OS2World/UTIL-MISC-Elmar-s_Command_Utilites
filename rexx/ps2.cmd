/* process viewer */
parse arg cmd opts
IF cmd == 'call' && opts == 'me' THEN CALL main
IF arg() == 0 THEN DO
  parse source os what me
  say me
  '@echo off'
  'pstat /c | 'me' call cat'
END
exit

ishex:
return Verify(ARG(1),xrange(0,9)||xrange('a','f'))==0

fmt:
return right(x2d(arg(1)),max(arg(2),length(arg(1))),'.')

main:

DO FOREVER
 DO i=1 TO 4; line=LineIn()
   IF line \= '' THEN LEAVE
 END; IF line == '' THEN return
 PARSE VAR line pid ppid
 IF ishex(pid) THEN LEAVE
END
psoffs=255; trailer=''; blocked=-1;

DO UNTIL line=='' 
 isnew=0
 IF substr(line,1,psoffs) \= copies(' ',psoffs) THEN DO
   psoffs = wordindex(line,4)-1; 
   IF psoffs<0 THEN psoffs=255; ELSE isnew=1;
 END
 IF isnew THEN DO
   PARSE VAR line pid ppid sid exe tid num pty state
   /* SAY x2d(pid) x2d(ppid) x2d(sid) exe */
   call PrepareState
   call CharOut ,threads||trailer||fmt(pid,4) fmt(ppid,4) fmt(sid,3)||" "
   threads=""; trailer=exe||d2c(10)||d2c(13); blocked=0;
   call ProcessState(state)
 END; ELSE DO
   PARSE VAR line tid num pty state
   call ProcessState(state)
 END
 DO i=1 TO 4; line=LineIn()
   IF line \= '' THEN LEAVE
 END;
END
call PrepareState
call CharOut ,threads||trailer
return

PrepareState:
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

