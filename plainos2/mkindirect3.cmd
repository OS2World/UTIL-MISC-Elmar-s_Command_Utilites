rem /* os/2  gcc - wlink compilation  */
wasm -q stackmain3.asm || return
gcc -c indirect3.c -o indirect3.o || return
emxomf indirect3.o || return
wlink option quiet system os2v2 File indirect3.obj File stackmain3.obj Library os2386 Option start=__asmstart_

