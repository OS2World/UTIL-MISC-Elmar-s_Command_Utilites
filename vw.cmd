/* view inf  files */
IF ARG(1,'O') THEN
  'dir C:\os2\book\*.inf /w'
ELSE DO
  PARSE ARG book command
  IF book == "cmd" THEN book="cmdref"
  '@start view C:\os2\book\'||book||'.inf '||command
END

