rem /* make with Open Watcom, only */
rem with debuginfo: owcc -g3 -fno-stack-check -fnostdlib direct3.c -Wl,"File stack.obj Library os2386 option start=_plainmain__"
owcc -fno-stack-check -fnostdlib direct3.c -Wl,"File stack.obj Library os2386 option start=_plainmain__"

