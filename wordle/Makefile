wordle.bin: wordle.o system.o
	ld wordle.o system.o -o wordle.bin

wordle.o: wordle.s
	as -g wordle.s -o wordle.o

system.o: system.s
	as -g system.s -o system.o

clean:
	rm *.o *.bin
