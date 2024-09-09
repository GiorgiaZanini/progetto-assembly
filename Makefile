AS_FLAGS = --32 
DEBUG = -gstabs
LD_FLAGS = -m elf_i386

all: bin/pianificatore

bin/pianificatore: obj/main.o obj/menu.o obj/salva_numeri.o obj/ordinamento_EDF.o obj/ordinamento_HPF.o obj/stampa_stringa.o obj/converti_str_a_int.o obj/converti_int_a_str.o obj/stampa_array.o obj/elabora_ordini.o obj/termina_programma.o 
	ld $(LD_FLAGS) obj/main.o obj/menu.o obj/salva_numeri.o obj/ordinamento_EDF.o obj/ordinamento_HPF.o obj/stampa_stringa.o obj/converti_str_a_int.o obj/converti_int_a_str.o obj/stampa_array.o obj/elabora_ordini.o obj/termina_programma.o -o bin/pianificatore

obj/main.o: src/main.s 
	as $(AS_FLAGS) $(DEBUG) src/main.s -o obj/main.o

obj/menu.o: src/menu.s 
	as $(AS_FLAGS) $(DEBUG) src/menu.s -o obj/menu.o

obj/salva_numeri.o: src/salva_numeri.s 
	as $(AS_FLAGS) $(DEBUG) src/salva_numeri.s -o obj/salva_numeri.o

obj/ordinamento_EDF.o: src/ordinamento_EDF.s 
	as $(AS_FLAGS) $(DEBUG) src/ordinamento_EDF.s -o obj/ordinamento_EDF.o

obj/ordinamento_HPF.o: src/ordinamento_HPF.s 
	as $(AS_FLAGS) $(DEBUG) src/ordinamento_HPF.s -o obj/ordinamento_HPF.o

obj/stampa_stringa.o: src/stampa_stringa.s 
	as $(AS_FLAGS) $(DEBUG) src/stampa_stringa.s -o obj/stampa_stringa.o

obj/converti_str_a_int.o: src/converti_str_a_int.s 
	as $(AS_FLAGS) $(DEBUG) src/converti_str_a_int.s -o obj/converti_str_a_int.o

obj/converti_int_a_str.o: src/converti_int_a_str.s 
	as $(AS_FLAGS) $(DEBUG) src/converti_int_a_str.s -o obj/converti_int_a_str.o

obj/stampa_array.o: src/stampa_array.s 
	as $(AS_FLAGS) $(DEBUG) src/stampa_array.s -o obj/stampa_array.o

obj/elabora_ordini.o: src/elabora_ordini.s 
	as $(AS_FLAGS) $(DEBUG) src/elabora_ordini.s -o obj/elabora_ordini.o

obj/termina_programma.o: src/termina_programma.s 
	as $(AS_FLAGS) $(DEBUG) src/termina_programma.s -o obj/termina_programma.o

clean:
	rm -f obj/*.o bin/pianificatore