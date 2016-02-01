/* pathp - print path line by line */

PATH = translate( value('PATH',,'OS2ENVIRONMENT'), ' ;', '; ' );

DO i=1 TO words(PATH)
  say translate( word(PATH,i), ' ;', '; ' )
END;

exit 0;
::requires common.rlb
