# as -o test.o test.s
# ld -o test.x test.o
# ./test.x

as test.s -32 -o test.o
ld test.o -m elf_i386 -o test.x
./test.x

# as -gstabs -o main.o main.s
# as -gstabs -o itoa.o itoa.s
# ld itoa.o main.o -o esempio_eseguibile