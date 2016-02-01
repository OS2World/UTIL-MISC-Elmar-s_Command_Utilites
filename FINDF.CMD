/* Find All Files  */
parse value arg(1) with arg1 arg2 
parse value SysFileTree(arg2, 'datei', 'FSO') with ret
IF ret!=0 THEN SAY "not enough memory"
IF ret!=0 THEN EXIT
echo off
do i=1 to datei.0
  /*dateien = dateien datei.i*/
  fgrep "-l" arg1 datei.i
end
/*fgrep "-l" arg1 dateien*/
