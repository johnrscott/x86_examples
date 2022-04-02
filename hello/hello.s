	/* Set Intel conventions for operand order and register naming */
	.intel_syntax noprefix

	.data
msg:
	.ascii "Hello\n"
	
	.text
	.global _start
_start:
	call print
	jmp exit
	
print:
	mov edx,7		/* message length */
	mov ecx, offset msg		/* message to write */
	mov ebx,1		/* file descriptor (stdout) */
	mov eax,4		/* system call number (sys_write) */
	int 0x80
	ret
	
	/* Return control to the operating system */
exit:
	mov ebx, 0
	mov eax, 1
	int 0x80
