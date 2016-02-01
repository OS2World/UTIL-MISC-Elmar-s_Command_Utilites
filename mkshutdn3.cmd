rem /* make with Open Watcom, only */
owcc -fno-stack-check -fnostdlib shutdn3.c -Wl,"File stack.obj Library os2386 option start=_cstart__"

