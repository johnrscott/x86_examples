	.global _start


	.equiv SA_RESTORER, 0x04000000
	.equiv ITIMER_REAL, 0
	.equiv STDOUT, 0

	.data
msg:	.ascii "Test\n"
	
	.text

restorer:
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
	agree with the man page */
sigaction:
	.8byte handler /* void (*sa_handler)(int);  */
	.8byte SA_RESTORER /* sa_flags */
	.8byte restorer
	.8byte 1 /* sa_mask */
timer:
	.int 0, 0
	.int 0, 0
	.int 2, 0 /* Timer value in seconds */
	.int 0, 0
	
	.text
	
	/* Exit with code zero */
exit:
	mov $60, %rax
	mov $0, %rdx
	syscall
	
	/* Set up alarm signal */
rt_sigaction:
	mov $13, %rax
	mov $14, %rdi /* ALARM */
	mov $sigaction, %rsi /* sigaction struct */
	mov $0, %rdx
	mov $8, %r10
	syscall
	ret
	
_start:
	/* Set up alarm handler */
	call rt_sigaction
	/* Set up timer */
	mov $38, %rax
	mov $ITIMER_REAL, %rdi
	mov $timer, %rsi
	mov $0, %rdx
	syscall
abc:	jmp abc
	jmp exit
