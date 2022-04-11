	.include "syscall.inc"

	.text
	.global _start
_start:
	mov $2, %rdi
	call exit
