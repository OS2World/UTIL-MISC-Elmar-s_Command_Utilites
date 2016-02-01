/* keyboard layout switcher */
/*call SysCls;*/

 /*do while queued()>0; pull; end;*/
 '@echo on'
 /*'@ keyb | rxEnQueue 1'*/
 '@ keyb | rxPushQueue 1'
 parse upper pull 'CURRENT KEYBOARD LAYOUT:' layout '.';
 layout=strip(layout,'both');
 /*say layout*/
parse source os what me

 'CHCP 850'
 IF layout=='GR' THEN DO
   'keyb br >NUL'
   call SysSetIcon me, 'bra.ico'
 END; ELSE DO
   'keyb gr >NUL';
   call SysSetIcon me, 'germany.ico'
 END;
 /*call SysSetObjectData(me,'OPEN=SETTINGS');*/
opok = SysOpenObject(me,'SETTINGS','FALSE');
/*call SysSleep(0.01)*/
sendmsg filespec('name',me) WM_CLOSE

exit



