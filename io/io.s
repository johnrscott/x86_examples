	.global _start


	.equiv SA_RESTORER, 0x04000000
	.equiv ITIMER_REAL, 0
	.equiv STDOUT, 0
	.equiv SIGIO, 29

	.data
msg:	.ascii "Test\n"
	
	.text

restorer:
	mov $15, %rax
	mov $0, %rdi
	syscall
	/* This function never returns */
	ret

handler:
	mov $1, %rax
	mov $STDOUT, %rdi
	mov $msg, %rsi
	mov $5, %rdx
	syscall
	ret
	
	.data

	/* I have no idea where this struct is documented. It does not
	agree with the man page (the mask should be before the flags) */
sigaction:
	.8byte handler /* void (*sa_handler)(int);  */
	.8byte SA_RESTORER /* sa_flags */
	.8byte restorer
	.8byte 0 /* sa_mask */

	.text
	
	/* Exit with code zero */
exit:
	mov $60, %rax
	mov $0, %rdx
	syscall
	
	/* Set up IO signal */
rt_sigaction:
	mov $13, %rax
	mov $SIGIO, %rdi /* IO */
	mov $sigaction, %rsi /* sigaction struct */
	mov $0, %rdx
	mov $8, %r10
	syscall
	ret

pause:
	mov $34, %rax
	syscall
	ret
	
_start:
	/* Set up alarm handler */
	call rt_sigaction
abc:	call pause
	jmp abc
	jmp exit
