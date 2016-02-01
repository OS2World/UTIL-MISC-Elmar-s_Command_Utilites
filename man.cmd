/* simple plain text man page viewer for OS2 based on groff */
/* Elmar Stellnberger, 12-2012 */

parse arg type page
IF page=="" THEN DO; type=""; parse arg page; END;

IF type\="" THEN
  filename = SysSearchPath('MANPATH','man'type'\'page'.'type);
ELSE
  DO type=1 TO 9;
    filename = SysSearchPath('MANPATH','man'type'\'page'.'type);
    IF filename\="" THEN leave;
  END;    

IF filename\="" THEN DO
  say 'please wait ...'
  'groff -t -man -Tascii' filename ' | less -man'
END

