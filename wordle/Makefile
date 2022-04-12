wordle.bin: wordle.o syscall.o io.o
	ld wordle.o syscall.o io.o -o wordle.bin

wordle.o: wordle.s
	as -g -I../syscall wordle.s -o wordle.o

syscall.o:
	as -g ../syscall/syscall.s -o syscall.o

io.o: io.s
	as -g -I../syscall io.s -o io.o

clean:
	rm *.o *.bin

