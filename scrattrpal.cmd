/* screen attributes (other than color) palette */

attr="0 1 4 5 6 7 8 9"
DO a=1 TO words(attr)
  say '1B'x'['word(attr,a)'m  attribute nr.'word(attr,a)'1B'x'[0m'
END;
say '1B'x'[0m'

