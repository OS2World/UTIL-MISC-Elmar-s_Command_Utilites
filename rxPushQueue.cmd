/* rxPushQueue: queue lines from stdin */
parse arg num qu

IF qu\='' THEN
  call rxQueue 'set', qu

IF arg(1,'E') THEN DO; j=1
  DO i=1 TO num WHILE lines();
    push linein(); j=j+1
  END;
  DO i=j TO num;
    push 'ERROR';
  END;

END; ELSE DO; j=0
  DO WHILE lines();
    push linein(); j=j+1;
  END;
  push j

END;


