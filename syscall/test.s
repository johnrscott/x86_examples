	.include "syscall.inc"

	.data
buf:	.ascii "Write some text and press enter: "
	
	.text
	.global _start
_start:
	/* write(STDOUT, "Write some text and press enter: ", 33); */
	mov $STDIN, %rdi
	mov $buf, %rsi
	mov $33, %rdx
	call write
	/* exit(2); */
	mov $2, %rdi
	call exit
