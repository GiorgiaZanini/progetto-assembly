# as -o test.o test.s
# ld -o test.x test.o
# ./test.x

# as ciao.s -32 -o ciao.o
# ld ciao.o -m elf_i386 -o ciao.x
# ./ciao.x

as main.s -32 -o main.o
as stampa_stringa.s -32 -o stampa_stringa.o
as converti_int_a_str.s -32 -o converti_int_a_str.o
ld main.o stampa_stringa.o converti_int_a_str.o -m elf_i386 -o main_2.x
./main_2.x

# as -gstabs -o main.o main.s
# as -gstabs -o itoa.o itoa.s
# ld itoa.o main.o -o esempio_eseguibile