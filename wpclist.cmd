/* configure mouse on startup */

parse upper arg search

call SysQueryClassList list.

do i=1 to list.0
  IF search='' | pos(search,translate(list.i))>0 THEN 
    say list.i
end;


