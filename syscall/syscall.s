	.text

	/* (no return) void exit(int status) */
	.global exit
exit:
	mov $60, %rax 
	syscall

	/* (no return) helper function to call exit(0) */
	.global exit_0
exit_0:	
	mov $0, %rdi
	call exit
