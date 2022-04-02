
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

	/* Write a string literal to the console. 
	*/
	.macro PUTS_LIT string
	.data
0:
	.ascii "\string"
	.equ len, .-0b
	.text
	WRITE 1, 0b, len
	.endm
	
	.data
msg:
	.ascii "Test\n"
	.equ msg_len, .-msg

	.text	
	.global _start
_start:
	WRITE 1, msg, msg_len
	PUTS_LIT "test and things"
	EXIT 0

