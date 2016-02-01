/* driveready: check whether drive is ready */
'@echo off'
parse arg drive_letter
drive_letter = delstr(drive_letter,2);

signal ON NOTREADY name 'NOT_READY'
parse upper value stream(drive_letter||':*', 'D') with desc
IF delstr(desc,8)='UNKNOWN' THEN signal 'UNKNOWN'

say "drive is ready ("desc")."
exit 0

NOT_READY:
say "drive is not ready."
exit 1

UNKNOWN:
say "state not known ("drive_letter":* exists ? -> '"desc"')."
exit 2

