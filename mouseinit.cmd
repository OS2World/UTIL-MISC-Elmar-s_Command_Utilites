/* configure mouse on startup */


MouseSettings="C:\Arbeitsoberfl„che\WPStickMouse - Object"
MouseSettings="<WPScrollMouse>"
 /*call SysSetObjectData(MouseSettings,'OPEN=SETTINGS');*/
res = SysOpenObject(MouseSettings,'DEFAULT','FALSE');
IF res = 1 THEN
  sendmsg "WPScrollMouse" WM_CLOSE
ELSE
  say "error opening "MouseSettings

exit




