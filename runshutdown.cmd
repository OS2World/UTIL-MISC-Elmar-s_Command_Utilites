
rem export CFLAGS="-Zmtd -D__ST_MT_ERRNO__"
rem export LDFLAGS="-Zmtd -D__ST_MT_ERRNO__ -Zsysv-signals"

// void _main() {
gcc -Wall -c -nostdlib shutdown-cons.c -o shutdown-cons.o -los2
ld shutdown-cons.o -o shutdown-cons.exe -los2
rem gcc -nostdlib shutdown-cons.o -o shutdown-cons.exe

