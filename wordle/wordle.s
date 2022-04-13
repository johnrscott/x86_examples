	.include "syscall.inc"
	.include "io.inc"
	.include "wordlist.inc"
	.include "utils.inc"
	
	.data

hit_msg:
	.ascii "Hit\n"
miss_msg:
	.ascii "Miss\n"

not_word:
	.ascii "   [Not a valid word]"

clear_line:
	.ascii "                               "
	
col_buf:
	.space 5, BLUE

guess:	
	.ascii "        "
answer:
	.ascii "        " /* Padded to make 8 bytes */
temp:
	.space 8 /* Extra space to allow 8-byte move */

ts_time:
	.int 0,0
	.int 250000000, 0 /* Sleep time, nanoseconds */


turn:	
	.ascii "1: " /* Increment the first character on each turn */

	
	.text

	/* Print colour-coded letters */
print:
	/* write(STDOUT, &turn, 3); */
	mov $STDOUT, %rdi
	mov $turn, %rsi
	mov $3, %rdx
	call write
	mov $guess, %r10
	/* Loop over all the letters in the guess */
begin:	cmp $guess+5, %r10
	je 0f
	/* Check if the letter is correctly placed */
	mov $temp, %r11
equal:	mov (%r10), %dil
	cmp 8(%r10), %dil
	jne search
	mov $GREEN, %rsi
	call putchar_colour
	jmp end
	/* If not, check if the letter is present anywhere */
search: cmp (%r11), %dil
	je hit
	cmp $temp+5, %r11
	je miss
	inc %r11
	jmp search	
miss:	mov $RED, %rsi
	call putchar_colour
	jmp end
	/* If found, remove the letter from the temp buffer */
hit:	mov $ORANGE, %rsi
	call putchar_colour
	movb $'.', (%r11)
end:	/* nanosleep(&ts_time, NULL); */
	mov $ts_time, %rdi
	xor %rsi, %rsi
	call nanosleep
	inc %r10
	jmp begin
	
0:	ret
	
	
	/* Copy the answer to a temporary buffer */
copy:
	mov answer, %r10
	mov %r10, temp
	ret

	/* Remove correctly placed letters from temp */
remove:
	mov $guess, %r10
0:	cmp $guess+5, %r10
	je 1f
	mov (%r10), %dil
	cmp 16(%r10), %dil
	jne 2f
	movb $'.', 16(%r10) 
2:	inc %r10
	jmp 0b
1:	ret
	
	.global _start
_start:
	/* get_random_word(&answer); */
	mov $answer, %rdi
	call get_random_word
	/* write(STDOUT, &answer, 5); */
	mov $STDOUT, %rdi
	mov $answer, %rsi
	mov $5, %rdx
	call write
	/* newline(); */
	call newline
	/* set_input_mode(); */
	call set_input_mode
	/* reset_count(); */
5:	call reset_count
	/* write(STDOUT, &turn, 3); */
	mov $STDOUT, %rdi
	mov $turn, %rsi
	mov $3, %rdx
	call write
0:	/* char c = listen_char() */
	call listen_char
	/* bool guess_is_ready = process_char(c, &guess); */
	mov %al, %dil
	mov $guess, %rsi
	call process_char
	/* if (!guess_is_ready) goto 0b; */
	cmp $0, %rax
	je 0b
	/* bool result = in_wordlist(&guess) */
	mov $guess, %rdi
	call in_wordlist
	cmp $0, %rax
	je 1f
	jmp 2f	
1:	/* Word is not in list */
	mov $STDOUT, %rdi
	mov $not_word, %rsi
	mov $21, %rdx
	call write
	mov $ts_time, %rdi
	xor %rsi, %rsi
	call nanosleep
	call nanosleep
	call nanosleep
	call nanosleep
	call carriage_return
	mov $STDOUT, %rdi
	mov $clear_line, %rsi
	mov $30, %rdx
	call write
	call carriage_return
	jmp 5b
	
2:	/* carriage_return(); */
	call carriage_return
	call print
	/* newline(); */
	call newline
	incb turn
	jmp 5b
	
	/* restore_input_mode() */
	call restore_input_mode
	
	call exit_0

	xor %r9, %r9
0:	cmp $5, %r9 /* only allow 5 guesses */
	je 1f
	/* read(STDIN, &guess, 6); */
	mov $STDIN, %rdi
	mov $guess, %rsi
	mov $6, %rdx
	call read
	
	call copy
	call remove
	call print
	inc %r9
	jmp 0b
1:	call exit_0
	
