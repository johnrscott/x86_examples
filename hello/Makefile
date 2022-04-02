hello.bin: hello.o
	ld -melf_i386 hello.o -o hello.bin

hello.o: hello.s
	as --32 hello.s -o hello.o

clean:
	rm *.o *.bin
