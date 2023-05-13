AFLAGS=-g

wordle.bin: wordle.o syscall.o io.o list.o utils.o sleep.o
	ld wordle.o io.o list.o syscall.o utils.o sleep.o -o wordle.bin

wordle.o: wordle.s
	as ${AFLAGS} -I../syscall wordle.s -o wordle.o

syscall.o:
	as ${AFLAGS} ../syscall/syscall.s -o syscall.o

io.o: io.s
	as ${AFLAGS} -I../syscall io.s -o io.o

list.o: list1.s
	as ${AFLAGS} -I../syscall list1.s -o list.o

utils.o: utils.s
	as ${AFLAGS} -I../syscall utils.s -o utils.o

sleep.o: sleep.s
	as ${AFLAGS} -I../syscall sleep.s -o sleep.o

clean:
	rm *.o *.bin

