@echo off
del %1.exe
copy %1.c c:\Apps\os2utils
gcc -Wall %1.c -o %1.exe && %1.exe %2 %3 %4 %5 %6 %7 %8

