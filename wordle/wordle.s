	.include "syscall.inc"
	.include "io.inc"
	.include "list.inc"
	.include "utils.inc"
	.include "sleep.inc"
	
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

turn:	
	.ascii "1: " /* Increment the first character on each turn */

congrats:
	.ascii "Well done!"

wrong:
	.ascii "The correct answer was "
	
	.text

	/* Print colour-coded letters */
	/* bool print() */
print:
	push %r12
	push %r13
	push %r14
	mov $1, %r14
	/* write(STDOUT, &turn, 3); */
	mov $STDOUT, %rdi
	mov $turn, %rsi
	mov $3, %rdx
	call write
	mov $guess, %r12
	/* Loop over all the letters in the guess */
begin:	cmp $guess+5, %r12
	je 0f
	/* Check if the letter is correctly placed */
	mov $temp, %r13
equal:	mov (%r12), %dil
	cmp 8(%r12), %dil
	jne search
	mov $GREEN, %rsi
	call putchar_colour
	jmp end
	/* If not, check if the letter is present anywhere */
search: cmp (%r13), %dil
	je hit1
	cmp $temp+5, %r13
	je miss
	inc %r13
	jmp search	
miss:	mov $RED, %rsi
	call putchar_colour
	mov $0, %r14
	jmp end
	/* If found, remove the letter from the temp buffer */
hit1:	mov $ORANGE, %rsi
	call putchar_colour
	mov $0, %r14
	movb $'.', (%r13)
end:	/* sleep_short(); */
	call sleep_medium
	inc %r12
	jmp begin
	
0:	mov %r14, %rax
	pop %r14
	pop %r13
	pop %r12
	ret
	
	
	/* void init_temp() */
init_temp:
	mov answer, %rsi
	mov %rsi, temp
	/* Remove correctly placed letters from temp */
	mov $guess, %rsi
0:	cmp $guess+5, %rsi
	je 1f
	mov (%rsi), %dil
	cmp 16(%rsi), %dil
	jne 2f
	movb $'.', 16(%rsi) 
2:	inc %rsi
	jmp 0b
1:	ret
	
	.global _start
_start:
	/* get_random_word(&answer); */
	mov $answer, %rdi
	call get_random_word
	/* write(STDOUT, &answer, 5); */
	/*
	mov $STDOUT, %rdi
	mov $answer, %rsi
	mov $5, %rdx
	call write
	*/
	/* newline(); */
	/*
	call newline
	*/
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
	/* sleep_long(); */
	call sleep_long
	call carriage_return
	mov $STDOUT, %rdi
	mov $clear_line, %rsi
	mov $30, %rdx
	call write
	call carriage_return
	jmp 5b
	
2:	/* init_temp(); */
	call init_temp
	/* carriage_return(); */
	call carriage_return
	/* bool success = print() */
	call print
	cmp $1, %rax
	je 1f
	/* newline(); */
	call newline
	incb turn
	cmpb $'6', turn
	je 3f
	jmp 5b

1:	call newline
	/* write(STDOUT, &congrats, 10); */
	mov $STDOUT, %rdi
	mov $congrats, %rsi
	mov $10, %rdx
	call write
	call sleep_long
	call newline
	jmp 2f

	/* write(STDOUT, &congrats, 11); */
3:	mov $STDOUT, %rdi
	mov $wrong, %rsi
	mov $23, %rdx
	call write
	mov $STDOUT, %rdi
	mov $answer, %rsi
	mov $5, %rdx
	call write
	call sleep_long
	call newline
	
	/* restore_input_mode() */
2:	call restore_input_mode
	
	call exit_0

