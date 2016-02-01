.386
;  public _asmstart_
;  .model flat, syscall
.model flat,stdcall
.stack 8192

extern C cmain : near
public _asmstart_

.code
_asmstart_:
  jmp cmain;

END
