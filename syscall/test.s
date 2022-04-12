	.include "syscall.inc"

	.data
buf1:	.ascii "Write some text and press enter: "
buf2:	.ascii "You wrote: "
buf3:	.space 20
	
	.text
	.global _start
_start:
	/* write(STDOUT, "Write some text and press enter: ", 33); */
	mov $STDOUT, %rdi
	mov $buf1, %rsi
	mov $33, %rdx
	call write
	/* int count = read(STDIN, &buf3, 20); */
	mov $STDIN, %rdi
	mov $buf3, %rsi	
	call read
	mov %rax, %r12 /* Save count in r12, preserved across calls */
	/* write(STDOUT, "You wrote: ", 11); */
	mov $STDOUT, %rdi
	mov $buf2, %rsi
	mov $11, %rdx
	call write
	/* write(STDOUT, $buf3 , count); */
	mov $STDOUT, %rdi
	mov $buf3, %rsi
	mov %r12, %rdx
	call write
	/* exit(2); */
	mov $2, %rdi
	call exit
