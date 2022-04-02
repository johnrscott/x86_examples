hello.bin: hello.o
	ld hello.o -o hello.bin

hello.o: hello.s
	as hello.s -o hello.o

clean:
	rm *.o *.bin
