	.include "syscall.inc"

	.data
buf:	
	.ascii "\033[1;3"
col:
	.ascii "Nm" /* Write the colour code to N */
char:
	.ascii "C\033[0m" /* Write the char to print to C */
	.equiv buf_len, .-buf

	.text
	
	/* void putchar_colour(int character, int colour) */
	.global putchar_colour
putchar_colour:
	mov %dil, char
	mov %sil, col
	mov $STDOUT, %rdi
	mov $buf, %rsi
	mov $buf_len, %rdx
	/* write(STDOUT, &buf, buf_len); */
	call write
	ret

	/* int putchar(int character) */
	.global putchar
putchar:
	mov %rdi, char
	mov $STDOUT, %rdi
	mov $char, %rsi
	mov $1, %rdx
	call write
	mov char, %rax
	ret
	
