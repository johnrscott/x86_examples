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
	
	.text

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

	
