wordle.bin: wordle.o syscall.o io.o wordlist.o utils.o
	ld wordle.o io.o wordlist.o syscall.o utils.o -o wordle.bin

wordle.o: wordle.s
	as -g -I../syscall wordle.s -o wordle.o

syscall.o:
	as -g ../syscall/syscall.s -o syscall.o

io.o: io.s
	as -g -I../syscall io.s -o io.o

wordlist.o: wordlist.s
	as -g -I../syscall wordlist.s -o wordlist.o

utils.o: utils.s
	as -g -I../syscall utils.s -o utils.o

clean:
	rm *.o *.bin

