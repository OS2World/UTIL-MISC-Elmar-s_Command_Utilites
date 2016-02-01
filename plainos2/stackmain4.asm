.386
;  public _asmstart_
;  .model flat, syscall
.model flat,stdcall
.stack 8192

extern C main : near
public __main

.code
  jmp main;

__main:
ret

END
