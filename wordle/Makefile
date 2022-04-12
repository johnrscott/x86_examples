wordle.bin: wordle.o syscall.o io.o wordlist.o
	ld wordle.o syscall.o io.o wordlist.o -o wordle.bin

wordle.o: wordle.s
	as -g -I../syscall wordle.s -o wordle.o

syscall.o:
	as -g ../syscall/syscall.s -o syscall.o

io.o: io.s
	as -g -I../syscall io.s -o io.o

wordlist.o: wordlist.s
	as -g wordlist.s -o wordlist.o

clean:
	rm *.o *.bin

