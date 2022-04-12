	/* Linux system calls are made by storing the system call number
	in rax, the register usually used for the return value. Then arguments
	to the system call are stored in the usual registers: rdi, rsi, rdx, etc.
	Finally, the syscall instruction is executed to begin the call. On return
	from the call, the return code from the system call (if the syscall
	returns) is available in rax. This makes it quite easy to write functions
	that obey the system V calling convention (because a return instruction
	will pass this value back to the caller, and the resulting function will
	have the usual prototype listed in the Linux max pages). */

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

	/* int write(int fd, void * buf, unsigned count) */
	.global write
write:
	mov $1, %rax
	syscall
	ret 

	/* int read(int fd, void * buf, unsigned count) */  
	.global read
read:
	mov $0, %rax
	syscall
	ret

	/* int nanosleep(const struct timespec *, struct timespec * rem) */
	.global nanosleep
nanosleep:
	mov $35, %rax
	syscall
	ret
	
