
	/* Exit program with code; use: "EXIT code". */
	.macro EXIT code
	mov $\code, %ebx
	mov $1, %eax
	int $0x80
	.endm

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

	.text	
	.global _start
_start:
	mov $'b', %edi
	mov $32, %esi
	call putchar
	EXIT 0

	.data
char_buf:	
	.ascii "\033[1;"
col:
	.ascii "34m" /* Write the two digit colour code to NN */
char:
	.ascii "C\033[0m" /* Write the char to print to C */
	.equ char_buf_len, .-char_buf

	.text	
	
	/* Print a single coloured char to the console.
	Pass the char C in edi, and the colour in esi (the integer
	NN that is used in the expression \033[1;NNm. 
	*/ 
putchar:
	mov %dil, char /* only move one byte to buffer */
	mov $char_buf_len, %edx
	mov $char_buf, %ecx
	mov $1, %ebx
	mov $4, %eax
	int $0x80
	ret
	
