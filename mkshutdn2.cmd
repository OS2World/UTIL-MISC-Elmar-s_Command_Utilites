rem /* os/2  gcc - wlink compilation  */
gcc -c shutdn2.c -o shutdn2.o
emxomf -z -m _cstart_ shutdn2.o
wlink system os2v2 File shutdn2.obj File stack.obj Library os2386 Option start=_cstart_

