# as -o test.o test.s
# ld -o test.x test.o
# ./test.x

as converti_int_a_str.s -32 -o converti_int_a_str.o
ld converti_int_a_str.o -m elf_i386 -o converti_int_a_str.x
./converti_int_a_str.x

# as -gstabs -o main.o main.s
# as -gstabs -o itoa.o itoa.s
# ld itoa.o main.o -o esempio_eseguibile