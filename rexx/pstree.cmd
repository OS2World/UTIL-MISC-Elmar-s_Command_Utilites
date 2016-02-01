/* process viewer */
parse arg cmd opts
IF cmd == 'call' && opts == 'me' THEN CALL main
IF arg() == 0 THEN DO
  parse source os what me
  /* say me */
  '@echo off'
  'pstat /c | 'me' call cat'
END
exit

ishex:
return Verify(ARG(1),xrange(0,9)||xrange('a','f'))==0

fmt:
return right(x2d(arg(1)),max(arg(2),length(arg(1))),'.')

in:
  push elm;push set;push j;
  parse arg elm; result=0;
  DO j=1 TO words(arg(2));
    IF elm==word(arg(2),j) THEN DO result=1;LEAVE; END
  END
  pull j;pull set;pull elm;
 return result


main:

DO FOREVER
 DO i=1 TO 4; line=LineIn()
   IF line \= '' THEN LEAVE
 END; IF line == '' THEN return
 PARSE VAR line pid ppid
 IF ishex(pid) THEN LEAVE
END
psoffs=255; blocked=-1; first=1;
arechilds=''; areparents='';

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
/* call PrintProcessTree 0 0000 */
/* all roots provided that tree is acyclic */
DO i=1 TO words(areparents); actparent=word(areparents,i)
  IF \ In(word(areparents,i),arechilds) THEN DO
    process.actparent='virtual process root'
    call PrintProcessTree 0 word(areparents,i)
END; END
return

AddProcess:
  process.pid=threads exe
  IF symbol('process.ppid.childs')=='LIT' 
    THEN process.ppid.childs=pid
    ELSE process.ppid.childs=pid process.ppid.childs
  arechilds=arechilds pid; IF \ In(ppid,areparents) THEN areparents=areparents ppid;
  /* say fmt(pid,4) fmt(ppid,4) fmt(sid,3) threads exe */
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

PrintProcessTree:
  push level; push root; push actpid; push i;
  parse arg level root
  say copies('  ',level)root':' process.root
  IF symbol('process.root.childs') == 'VAR' THEN DO i=1 TO words(process.root.childs);
    actpid = word(process.root.childs,i)
    call PrintProcessTree level+1 actpid
  END
  pull i; pull actpid; pull root; pull level;
return

