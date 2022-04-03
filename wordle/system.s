
	.global putchar
	.global read_line
	.global read_buf
	.global answer
	
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
read_buf:	
	.space 5
answer:
	.ascii "hello"
	.equ answer_offset, read_buf-answer

	
	.text
	/* Read a single line from the terminal. Result will be stored
	in the read_buf. Only a maximum of 20 characters will be stored.
	*/
read_line:
	mov $6, %edx /* Not sure why 6 is needed -- maybe newline? */
	mov $read_buf, %ecx
	mov $1, %ebx
	mov $3, %eax
	int $0x80
	ret
