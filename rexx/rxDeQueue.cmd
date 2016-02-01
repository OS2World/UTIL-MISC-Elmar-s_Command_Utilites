/*  rxDequeue: emit queued lines to stdout */

parse arg qu
IF qu\='' THEN
  call rxQueue 'set', qu

DO WHILE queued()>0
  parse pull line
  Say line
END;

