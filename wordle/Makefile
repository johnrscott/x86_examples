wordle.bin: wordle.o syscall.o io.o list.o utils.o sleep.o
	ld wordle.o io.o list.o syscall.o utils.o sleep.o -o wordle.bin

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

sleep.o: sleep.s
	as -g -I../syscall sleep.s -o sleep.o

clean:
	rm *.o *.bin

