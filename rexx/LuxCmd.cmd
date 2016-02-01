/* extended cmdline */

call RxFuncAdd 'SysTextScreenSize', 'RexxUtil', 'SysTextScreenSize'
parse value SysTextScreenSize() with yscr xscr;
/* call SysCls; */
call SysCurState 'ON';
SIGNAL Main

EPos:
  result = Pos(arg(1),arg(2),arg(3));
  IF result = 0 THEN result = length(arg(2))+1;
  RETURN result;

Rem1:       /* (arg(1)+arg(2)) % arg(3),  0<arg(1),arg(2)<arg(3) */
  result = arg(1) + arg(2);
  if result<0 then return result+arg(3)
  else if result>=arg(3) then return result-arg(3)
  else return result;

Mod:
  return ( arg(1)/arg(2) - trunc(arg(1)/arg(2)) ) * arg(2);

CurPos:
  IF \( datatype(ARG(1)) = 'NUM' ) THEN Say -- ARG(1) -- cur --
  push xpos; push ypos;
  xpos = splt+ARG(1); ypos = zl;
  DO WHILE xpos > xscr-1; xpos=xpos-xscr; ypos=ypos+1; END;
  DO WHILE ypos > yscr-1; zl=zl-1; ypos=ypos-1; call SysCurPos yscr-1,xscr-1; call CharOut ,''; END;
  /* call SysCurPos 3,3; say xpos ';' ypos '  ' */
  call SysCurPos ypos, xpos;
  pull ypos; pull xpos;
  return;

Eingabe:

/* if \ setlocal()=1 then say 'error: out of stack.'  */
push cur; push key; push str; push hptr; push newhptr; push hstop; push padlen;
call CharOut ,ARG(1);
parse value SysCurPos() with zl splt; splt=splt-1;
str = ARG(2); cur = length(str)+1;
call CharOut ,str;
hptr = Rem1(acthist,+1,maxhist); hstop = hptr;
didyank = 0;

DO UNTIL key=d2c(13)
  key = SysGetKey(NOECHO); IF \( key=d2c(23) ) THEN didyank=0;  /* yank left */
  SELECT
    WHEN c2d(key) >= c2d(' ') & c2d(key) < 224 THEN DO
      str = Insert(key,str,cur-1);
      call CharOut ,substr(str,cur); IF mod((length(str)+splt+1),xscr)=0 THEN zl=zl-1;
      cur = cur + 1;
      call CurPos cur;
    end 
    WHEN key = d2c(224) THEN DO
      key = SysGetKey(NOECHO);
      SELECT
         WHEN key = 'K' THEN DO  /* Left */
            cur = max(1,cur-1);
            call CurPos cur;
         end /* do */    
         WHEN key = 'M' THEN DO  /* Right */
            cur = min(length(str)+1,cur+1)
            call CurPos cur;
         end /* do */
         WHEN key = d2c(71) THEN DO; cur=1; call CurPos cur; END;         /* Home,Pos1 */
         WHEN key = d2c(79) THEN DO; cur=length(str)+1; call CurPos cur; END   /* End */
         WHEN key = 's' THEN DO      /* [Ctrl][Left]  */
            IF cur>1 THEN cur = max(1,LastPos(' ',str,cur-1));
            call CurPos cur;
         end /* do */
         WHEN key = 't' THEN DO      /* [Ctrl][Right] */
            IF cur<length(str) THEN DO
               cur = Pos(' ',str,cur+1); IF cur=0 THEN cur=length(str)+1;
            END; ELSE cur = length(str)+1;
            call CurPos cur;
         end /* do */
         WHEN key = 'H' THEN DO     /* History Up */
           padlen = length(str);
           IF hptr = hstop THEN history.hstop = str;
           newhptr = Rem1( hptr, - 1, maxhist ); IF \(history.newhptr='' | newhptr=hstop)  THEN DO; hptr = newhptr;
             str = history.hptr; cur = length(str)+1; padlen=max(padlen,length(str));
             call CurPos 1; call CharOut ,left(str,padlen); call CurPos cur; 
         end; end
         WHEN key = 'P' THEN IF \(hptr=hstop) THEN DO     /* History Down */
           padlen = length(str);
           hptr = Rem1( hptr, + 1, maxhist );
           str = history.hptr; cur = length(str)+1; padlen=max(padlen,length(str));
           call CurPos 1; call CharOut ,left(str,padlen); call CurPos cur; 
         end
      OTHERWISE NOP/* Say '#224#'c2d(key); */
      END  /* select 2 */
    END
    WHEN key = d2c(8) THEN IF cur>1 THEN DO    /* Backspace */
      str = DelStr(str,cur-1,1); cur=cur-1; call CurPos cur;
      call CharOut ,substr(str,cur)' '; call CurPos cur;
    END
    WHEN key = d2c(0) THEN DO
      key = SysGetKey(NOECHO);
      SELECT
        WHEN key = 'S' THEN IF cur<=length(str) THEN DO    /* Entf, Del */
          str = DelStr(str,cur,1);
          call CharOut ,substr(str,cur)' '; call CurPos cur;
        end
        WHEN key = d2c(155) THEN DO   /* [Alt][Left] */
           IF cur>1 THEN cur = max(1,max(LastPos('\',str,cur-1),LastPos(' ',str,cur-1)));
           call CurPos cur;
        end /* do */
        WHEN key = d2c(157) THEN DO
           IF cur<length(str) THEN DO    /* [Alt][Right] */
              cur = min(EPos('\',str,cur+1),EPos(' ',str,cur+1));
           END; ELSE cur = length(str)+1;
           call CurPos cur;
        end /* do */
        WHEN key = d2c(152) THEN DO     /* History UpwardSearch */
          padlen = length(str); seek=substr(str,1,cur-1);
          IF hptr = hstop THEN history.hstop = str;
          newhptr = hptr;
          DO UNTIL substr(history.newhptr,1,length(seek))=seek | history.newhptr='' | newhptr=hstop
            newhptr = Rem1( newhptr, - 1, maxhist ); 
          END;
          IF \(history.newhptr='' | newhptr=hstop)  THEN DO
            hptr = newhptr; str = history.hptr; padlen=max(padlen,length(str));
            call CurPos 1; call CharOut ,left(str,padlen); call CurPos cur; 
        end; end
        WHEN key = d2c(160) THEN DO     /* History Downward Search */
          padlen = length(str); seek=substr(str,1,cur-1); newhptr=hptr;
          DO UNTIL substr(history.newhptr,1,length(seek))=seek | newhptr=hstop;
            newhptr = Rem1( newhptr, + 1, maxhist );
          END;
          IF \(hptr=hstop) THEN DO; hptr=newhptr;
            str = history.hptr; padlen=max(padlen,length(str));
            call CurPos 1; call CharOut ,left(str,padlen); call CurPos cur; 
        end; end
      OTHERWISE Say '#0#'c2d(key);
      END  /* select 2 */
    END
    WHEN key = d2c(27) THEN DO;  /* set input '' */
       call CurPos 1; call CharOut ,copies(' ',length(str));
       call CurPos 1; str=''; cur=1;
    END /* when */
    WHEN key = d2c(21) THEN DO;  /* [ctrl][u] ... yank to the beginning of line */
      yankbuf = substr(str,1,cur-1); str = substr(str,cur);
      call CurPos 1; call CharOut ,(str)(copies(' ',length(yankbuf)));
      call CurPos 1; cur=1;
    END /* when */
    WHEN key = d2c(23) THEN IF cur>1 THEN DO;  /* [ctrl][w] ... yank the word on the left */
      IF \didyank THEN yankbuf = '';   didyank = 1;
      yankpos = cur-1; DO WHILE yankpos>1 & substr(str,yankpos,1)=' '; yankpos=yankpos-1; END;
      yankpos = LastPos(' ',str,yankpos)+1;
      yankbuf = (substr(str,yankpos,cur-yankpos))(yankbuf); str = substr(str,1,yankpos-1)substr(str,cur);
      call CurPos 1; call CharOut ,(str)(copies(' ',length(yankbuf)));
      cur = yankpos; call CurPos cur;
    END /* when */
    WHEN key = d2c(25) THEN DO;    /* [ctrl][y] ... paste yankbuf */
      call CharOut ,(yankbuf)(substr(str,cur))
      str = (substr(str,1,cur-1))(yankbuf)(substr(str,cur))
      cur = cur + length(yankbuf); call CurPos cur;
    END /* when */
    OTHERWISE 
      IF \( key=d2c(13) ) THEN Say '&'c2d(key);
  END  /* select 1 */
END
call CharOut ,d2c(13)d2c(10);
/*n=endlocal();*/
result = str; IF \(str='') THEN DO; acthist = hstop; history.hstop = str; END;
pull padlen; pull hstop; pull newhptr; pull hptr; pull str; pull key; pull cur;
return result

KeyCodes:
  do until key = d2c(13)
    key = SysGetKey();
    Say c2d(key);
   end
return

HstEingabe:
push str;
  str = Eingabe(arg(1),arg(2),1);
  acthist = ( acthist + 1 ) % maxhist;
  history.acthist = str;
result = str;
pull str;
return result;

InitHst:
  do acthist=0 to maxhist-1; history.acthist=''; end;
  history.0 = 'type x.bat'
  history.1 = 'ls -l'
  history.2 = 'pwd'
  history.3 = 'ls *'
  history.4 = 'cd ..'
  history.5 = 'dir'
  acthist=5;
return

Main:
stack = RxQueue('Create'); /* do not use result when calling self defined functions */
stdio = RxQueue('Set',stack);
/* call KeyCodes */

maxhist=500; call InitHst;
DO UNTIL str=''
  str = Eingabe('eingeben: ','ABC DEF GHI JKL MNO PQR STU VWX YZ abc def ghi jkl mno pqr stu vwx yz');
  Say "Eingabe:-"str"-("length(str)")";
END

