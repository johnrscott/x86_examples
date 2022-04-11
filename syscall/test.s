	.include "syscall.inc"

	.text
	.global _start
_start:
	/* write(STOUT, "Write some text and press enter: ", 33); */
	
	/* exit(2); */
	mov $2, %rdi
	call exit
