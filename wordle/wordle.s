
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
	.macro PUTS string
	.data
0:
	.ascii "\string"
	.equ len, .-0b
	.text
	WRITE 1, 0b, len
	.endm

	/* Print a single char to stdout. */
	.macro
	
	/* Write a string literal to the console. */
	.macro PUTS_G string
	PUTS "\033[1;32m\string\033[0m"
	.endm

	/* Write a string literal to the console. */
	.macro PUTS_R string
	PUTS "\033[1;31m\string\033[0m"
	.endm

	/* Write a string literal to the console. */
	.macro PUTS_B string
	PUTS "\033[1;34m\string\033[0m"
	.endm

	
	.data
msg:
	.ascii "Test\n"
	.equ msg_len, .-msg

	.text	
	.global _start
_start:
	WRITE 1, msg, msg_len
	PUTS_R "test and things\n"
	PUTS_G "test and things\n"
	PUTS_B "test and things\n"
	PUTS "test and things\n"

	EXIT 0

