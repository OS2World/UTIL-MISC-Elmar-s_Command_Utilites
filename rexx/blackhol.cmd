/**/
dll = 'BLACKHOL.DLL'
class.0 = 1
class.1 = 'BlackHole'
/**/
call RxFuncAdd 'SysLoadFuncs', 'REXXUTIL', 'SysLoadFuncs'
call SysLoadFuncs
arg opt
select
  when opt = 'I' then do
    call SysFileTree dll, 'stem', 'O'
    if stem.0 = 0 then
      say 'Unable to locate' dll
    else do
      do i = 1 to class.0
	call register class.i
      end
      call createobj
    end
  end
  when opt = 'U' then do
    call deleteobj
    do i = 1 to class.0
      call deregister class.i
    end
  end
  otherwise
    parse upper source . . me
    me = filespec('N', me)
    say
    say 'Usage:' left(me, lastpos('.', me) - 1) '<option>'
    say
    say 'Option is: I - Install'
    say '           U - Uninstall'
end
return

register:
  parse arg newclass
  call charout , 'Registering class' newclass': '
  if SysRegisterObjectClass(newclass, stem.1) \= 0 then
    say 'Success'
  else
    say 'Failure'
  return

deregister:
  parse arg newclass
  call charout , 'Deregistering class' newclass': '
  if SysDeregisterObjectClass(newclass) \= 0 then
    say 'Success'
  else
    say 'Failure'
  return

createobj:
  call charout , 'Creating Black Hole object: '
  if SysCreateObject('BlackHole', 'Black Hole', '<WP_DESKTOP>',,
      'OBJECTID=<BLACKHOLE>') \= 0 then
    say 'Success'
  else
    say 'Failure'
  return

deleteobj:
  call charout , 'Deleting Black Hole object: '
  if SysDestroyObject('<BLACKHOLE>') \= 0 then
    say 'Success'
  else
    say 'Failure'
  return
