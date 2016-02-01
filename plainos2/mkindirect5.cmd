rem /* os/2  gcc - wlink compilation  */
wasm -q stackmain.asm || return
gcc -c indirect5.c -o indirect5.o || return
emxomf -m _main indirect5.o || return
@rem wlink option quiet system os2v2 File indirect5.obj File stackmain.obj Library os2386 Option start=__asmstart_
wlink option quiet system os2v2 File indirect5.obj File stackmain.obj Library os2386

