	/* Set Intel conventions for operand order and register naming */
	.intel_syntax noprefix

	/* Start the data section, for storing a string to print */
	.data
msg:
	.ascii "Hello\n"
	.equ msg_len, .-msg 

	/* Start the text section (for code) */
	.text

	/* Make the entry point accessible to the linker. */
	.global _start

	/* Define the entry point for the program. The name is fixed
	by a convention so that the linker can find it.
 	*/ 
_start:
	call print
	jmp exit

	/* Print a string by calling the write() system call
	*/
print:
	mov edx, msg_len		/* message length */
	mov ecx, offset msg		/* message to write */
	mov ebx,1		/* file descriptor (stdout) */
	mov eax,4		/* system call number (sys_write) */
	int 0x80
	ret
	
	/* Return control to the operating system, by calling
	the exit() system call. */
exit:
	mov ebx, 0
	mov eax, 1
	int 0x80
