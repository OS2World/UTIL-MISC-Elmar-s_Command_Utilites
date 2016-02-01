rem /* os/2  gcc - wlink compilation  */
wasm -q stackmain.asm || return
gcc -c indirect4.c -o indirect4.o || return
emxomf -m _main indirect4.o || return
@rem wlink option quiet system os2v2 File indirect4.obj File stackmain.obj Library os2386 Option start=__asmstart_
wlink option quiet system os2v2 File indirect4.obj File stackmain.obj Library os2386

