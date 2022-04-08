
	.global putchar
	.global read
	.global guess
	.global answer
	.global temp
	.global wait
	.global signal



	.equiv SA_RESTORER, 0x04000000
	.equiv ITIMER_REAL, 0
	.equiv STDOUT, 0
	
	.text
/* Handler for the alarm signal. Do nothing and return */

alarm_handler:
	ret
	
	
restorer:
	mov $15, %rax
	mov $0, %rdi
	syscall
	/* This function never returns */
	ret
		
	.data
	/* Timer data structure. Set timer_usec to non-zero to enable. */
timer:
	.int 0, 0
	.int 0, 0
	.int 1, 0 /* Timer value in seconds */
	.int 0, 0

	/* I have no idea where this struct is documented. It does not
	agree with the man page (the mask should be before the flags) */
sigaction:
	.8byte alarm_handler /* void (*sa_handler)(int);  */
	.8byte SA_RESTORER /* sa_flags */
	.8byte restorer
	.8byte 1 << 13 /* sa_mask */
	
	.text	
	
	.text
	/* Perform signal setup here (using sigaction) */
signal:
	mov $13, %rax
	mov $14, %rdi /* ALARM */
	mov $sigaction, %rsi /* sigaction struct */
	mov $0, %rdx
	mov $8, %r10
	syscall
	ret
	
pause:
	mov $34, %rax
	syscall
	ret
	
wait:
	/* Set up timer */
	mov $38, %rax
	mov $ITIMER_REAL, %rdi
	mov $timer, %rsi
	mov $0, %rdx
	syscall
	call pause
	ret
	
	.data
char_buf:	
	.ascii "\033[1;3"
col:
	.ascii "Nm" /* Write the colour code to N */
char:
	.ascii "C\033[0m" /* Write the char to print to C */
	.equ char_buf_len, .-char_buf
	
	.text

	/* Write to a file descriptor; use: "WRITE fd, buf, count".
	fd is an integer literal, buf is a symbol pointing to memory,
	and count is a constant count for the number of bytes to write. */
	.macro WRITE fd, buf, count
	mov $\count, %edx
	mov $\buf, %ecx
	mov $\fd, %ebx
	mov $4, %eax
	int $0x80
	.endm

	/* Read from a file descriptor; use: "READ fd, buf, count".
	fd is an integer literal, buf is a symbol pointing to memory,
	and count is a constant count for the number of bytes to write. */
	.macro READ fd, buf, count
	mov $\count, %edx
	mov $\buf, %ecx
	mov $\fd, %ebx
	mov $3, %eax
	int $0x80
	.endm
	/* Print a single coloured char to the console.
	Pass the char C in edi, and the colour in esi (the integer
	NN that is used in the expression \033[1;NNm. 
	*/ 
putchar:
	mov %dil, char /* only move one byte to buffer */
	mov %sil, col /* Move colour code to the buffer */
	mov $char_buf_len, %edx
	mov $char_buf, %ecx
	mov $1, %ebx
	mov $4, %eax
	int $0x80
	ret

	.data
guess:	
	.space 8
answer:
	.ascii "apple\n  " /* Padded to make 8 bytes */
temp:
	.space 8 /* Extra space to allow 8-byte move */
	
	
	.text
	/* Read a single line from the terminal. Result will be stored
	in the read_buf. Only a maximum of 20 characters will be stored.
	*/
read:
	mov $6, %edx
	mov $guess, %ecx
	mov $1, %ebx
	mov $3, %eax
	int $0x80
	ret
