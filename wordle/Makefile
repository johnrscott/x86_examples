wordle.bin: wordle.o
	ld wordle.o -o wordle.bin

wordle.o: wordle.s
	as -g wordle.s -o wordle.o

clean:
	rm *.o *.bin
