AFLAGS=-g

asmdle.bin: asmdle.o syscall.o io.o list.o utils.o sleep.o
	ld asmdle.o io.o list.o syscall.o utils.o sleep.o -o asmdle.bin

asmdle.o: asmdle.s
	as ${AFLAGS} -I../syscall asmdle.s -o asmdle.o

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

