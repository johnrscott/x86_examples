	.global _start


	.text


	
	.data
	
sigaction:
	.int 0,0
	.int 

	
	.text

handler:
	ret
	
	/* Exit with code zero */
exit:
	mov $60, %rax
	mov $0, %rdx
	syscall

	/* Set up alarm signal */
rt_sigaction:
	mov handler, %rax
	mov %rax, sigaction
	mov $13, %rax
	mov $14, %rdx /* ALARM */
	
	
_start:
	jmp exit
