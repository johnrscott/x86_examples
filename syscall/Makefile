all: testc.bin test.bin

test.bin: test.o syscall.o
	ld test.o syscall.o -o test.bin

test.o: test.s syscall.inc
	as test.s -o test.o

syscall.o: syscall.s syscall.s
	as syscall.s -o syscall.o

testc.bin: testc.c syscall.o
	gcc testc.c syscall.o -o testc.bin
