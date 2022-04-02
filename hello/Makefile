hello.bin: hello.o
	ld hello.o -T link.ld -o hello.bin

hello.o: hello.s
	as hello.s -o hello.o
