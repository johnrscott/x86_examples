
	.global putchar
	.global read
	.global guess
	.global answer
	.global temp
	.global wait
	.global signal

	.text

trampoline:
	call sigreturn
	
sigreturn:
	mov $129, %eax
	int $0x80
	/* The return below will not execute in normal use */
	ret
	
	.data
	/* Timer data structure. Set timer_usec to non-zero to enable. */
timer_data:
	.int 0,0
timer_usec:
	.int 1,0

action:
	.int alarm /* sa_handler */
	.int 0 /* sa_mask */
	.int 0x14000000 /* sa_flags = SA_RESTORER */
	.int trampoline /* sa_restorer */
	
	.text	
	/* Handler for the alarm signal. Do nothing and return */
alarm:
	ret
	
	.text
	/* Perform signal setup here (using sigaction) */
signal:
	mov $67, %eax
	mov $14, %ebx /* SIGALRM */
	mov $action, %ecx
	mov $0, %edx
	int $0x80
	ret

pause:
	mov $29, %eax
	int $0x80
	/* The signal handler will jump here */
cont:	ret	
	
wait:
	mov $104, %eax
	mov $0, %ebx /* Timer type */
	mov $timer_data, %ecx /* New timer data */
	mov $0, %edx /* Old timer data (null) */
	int $0x80
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
