wordle.bin: wordle.o syscall.o io.o list.o utils.o
	ld wordle.o io.o list.o syscall.o utils.o -o wordle.bin

wordle.o: wordle.s
	as -g -I../syscall wordle.s -o wordle.o

syscall.o:
	as -g ../syscall/syscall.s -o syscall.o

io.o: io.s
	as -g -I../syscall io.s -o io.o

list.o: list.s
	as -g -I../syscall list.s -o list.o

utils.o: utils.s
	as -g -I../syscall utils.s -o utils.o

clean:
	rm *.o *.bin

