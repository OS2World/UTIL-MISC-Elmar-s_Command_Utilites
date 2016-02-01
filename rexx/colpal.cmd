/* Farbpalette - color palette   */
/* Elmar Stellnberger, 12-2012 */

SELECT
  WHEN arg(1)=='help' THEN DO; Say 'colpal / colpal white/gray/grayblack'; exit 0; END; 
  WHEN arg(1)=='white' THEN DO; bg='47;';fg=';30';hl=0;fhl='[0;'; END;
  WHEN arg(1)=='gray' THEN DO; bg='';fg=';30';hl='5';fhl='[5;'; END; 
  WHEN arg(1)=='grayblack' THEN DO; bg='';fg=';30';hl='0;5';fhl='[5;'; END; 
  OTHERWISE DO; bg='';fg=';37';hl=1;fhl='[0;'; END;
END;

DO c=0 TO 7;
  call charout, '1B'x||fhl||bg||'3'c'm  Farbe nr 3'c'(dunkel) '||'1B'x'[1;'||bg||'3'c'm  Farbe nr 3'c'(hell)  '
  call charout, '1B'x'['||hl||';4'c||fg'm Hintergrundfarbe nr 4'c' '||'1B'x'[0m'||'0D0A'x
END;
call charout, '1B'x'[0m'

