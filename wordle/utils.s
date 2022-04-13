	.include "syscall.inc"
	
	.data

	/* A set of special characters and character sequences */
buf1:
	.ascii "\n\r\b \b"

	/* For storing the old termios struct */
buf2:
	.int 0 /* c_iflag, input modes */
	.int 0 /* c_oflag, output modes */
	.int 0 /* c_cflag, control modes */
	.int 0 /* c_lflag, local modes */
	.space 8, 0 /* c_cc[8] */

	/* For storing the new termios struct */
buf3:
	.int 0 /* c_iflag, input modes */
	.int 0 /* c_oflag, output modes */
	.int 0 /* c_cflag, control modes */
	.int 0 /* c_lflag, local modes */
	.space 8, 0 /* c_cc[8] */

	/* Buffer for storing the result of character reads, and for writing */
buf4:	
	.space 8, 0

	/* Counter for current number of chars on line */
count:
	.int 0
	
	.text

	/* reset_count() */
	.global reset_count
reset_count:
	movw $0, count
	ret
	
	/* bool process_char(int character, char * buf) */
	.global process_char
process_char:	
	/* Look for special characters */
	cmp $'\n', %dil
	je 1f
	cmp $127, %dil
	je 2f
	
	/* Handle printable character */
	mov count, %rdx
	/* If guess already has five letters, do nothing else */
	cmp $5, %rdx
	je 3f
	movb %dil, (%rsi, %rdx, 1)
	incw count
	call putchar
	jmp 3f
	
1:	/* Handle newline */
	cmp $5, count
	je 4f
	mov $0, %rax /* Return false */ 
	ret
4:	mov $1, %rax /* Return true */
	ret
	
2:	/* Handle backspace */
	decw count
	call backspace
	jmp 3f
	
3:	mov $0, %rax
	ret

	
	/* int putchar(int character) */
	.global putchar
putchar:
	mov %rdi, buf4
	mov $STDOUT, %rdi
	mov $buf4, %rsi
	mov $1, %rdx
	call write
	mov buf4, %rax
	ret
	
	/* char listen_char() */
	.global listen_char
listen_char:
	mov $STDIN, %rdi
	mov $buf4, %rsi
	mov $8, %rdx
	call read
	mov buf4, %al 
	ret
	
	/* void set_input_mode() */
	.global set_input_mode
set_input_mode:
	/* ioctl(STDOUT, TCGETS, &buf2); */
	mov $STDOUT, %rdi
	mov $TCGETS, %rsi
	mov $buf2, %rdx
	call ioctl
	/* Copy structure */
	xor %rcx, %rcx
	mov $buf2, %rdi
	mov $buf3, %rsi
0:	mov (%rdi, %rcx, 4), %rdx
	mov %rdx, (%rsi, %rcx, 4)
	inc %rcx
	cmp $6, %rcx
	jne 0b
	/* Modify c_lflag */
	and $(~ICANON & ~ECHO), 12(%rsi)
	/* ioctl(STDOUT, TCSETS, &buf3); */
	mov $STDOUT, %rdi
	mov $TCSETS, %rsi
	mov $buf3, %rdx
	call ioctl
	ret

	/* void restore_input_mode() */
	.global restore_input_mode
restore_input_mode:
	/* ioctl(STDOUT, TCSETS, &buf2); */
	mov $STDOUT, %rdi
	mov $TCSETS, %rsi
	mov $buf2, %rdx
	call ioctl
	ret

	
	/* void newline(); */
	.global newline
newline:
	mov $STDOUT, %rdi
	mov $buf1, %rsi
	mov $1, %rdx
	call write
	ret

	/* void carriage_return(); */
	.global carriage_return
carriage_return:
	mov $STDOUT, %rdi
	mov $buf1+1, %rsi
	mov $1, %rdx
	call write
	ret

	/* void backspace(); */
	.global backspace
backspace:
	mov $STDOUT, %rdi
	mov $buf1+2, %rsi
	mov $3, %rdx
	call write
	ret

	
