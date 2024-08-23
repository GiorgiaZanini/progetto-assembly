# as -o test.o test.s
# ld -o test.x test.o
# ./test.x

as salva_numeri_2.s -32 -o salva_numeri_2.o
ld salva_numeri_2.o -m elf_i386 -o salva_numeri_2.x
./salva_numeri_2.x

# as -gstabs -o main.o main.s
# as -gstabs -o itoa.o itoa.s
# ld itoa.o main.o -o esempio_eseguibile