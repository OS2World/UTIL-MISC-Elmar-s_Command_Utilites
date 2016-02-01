rem /* os/2  gcc - wlink compilation  */
gcc -c direct2.c -o direct2.o || exit
emxomf -z -m _plainmain_ direct2.o || exit
wlink option quiet system os2v2 File direct2.obj File stack.obj Library os2386 Option start=_plainmain_

