rm *.o *.so *.lib test

gcc -fPIC -c mul.c
gcc -shared -o libmul.so mul.o
gcc -L$(pwd) -Wl,-rpath=$(pwd) -o test main.c -lmul -g

cp mul.h thirdparty/linux/include/
cp libmul.so thirdparty/linux/lib/x64/

cp mul.h thirdparty/Mac/include/
cp libmul.so thirdparty/Mac/lib/x64/
