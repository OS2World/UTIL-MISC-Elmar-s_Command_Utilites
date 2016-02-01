/* character palette */
/* Elmar Stellnberger 12-2012 */

call SysCls;

DO x=0 TO 15;
  call SysCurPos 1,x*3+3; say d2x(x)
END;

DO y=0 TO 15;
  call SysCurPos y+2,0; say d2x(y)
  DO x=0 TO 15;
    call SysCurPos y+2,x*3+3; say d2c(y*16+x)||'_'
  END;
END;
call SysCurPos 18,0;
say 'Aaaaa'||'0A'x||'bbbb -> 0Ax'
say 'Aaaaa'||'0D'x||'bbbb -> 0Dx'
say '07x: BEL, 08x: BS, 09x: TAB, 1Bx: ESC'

