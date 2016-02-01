/* Sample code to display all object ids known to the WPS.            */
/* Captured from a message in a public CompuServe Forum               */
/*                                                                    */

call rxFuncAdd "SysIni", "REXXUTIL", "SysIni"

INIFILE=SYSTEM
INIFILE=USER

call SysIni INIFILE, "PM_Workplace:Location", "All:", "ids."

parse upper arg search

/* query object informations: */
/* eCs only: wps*.inf, wpQueryObjData */


call SysIni INIFILE, "All:", "types."

do t=0 TO types.0
  call SysIni "USER", types.t, "All:", "ids."
  do i=0 to ids.0
    IF search='' | Pos(search,translate(ids.i))>0 THEN
      say types.t ids.i
  end
end


