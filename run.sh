# as -o test.o test.s
# ld -o test.x test.o
# ./test.x

as test.s -32 -o test.o
ld test.o -m elf_i386 -o test.x
./test.x