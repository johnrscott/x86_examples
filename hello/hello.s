	/* Set Intel conventions for operand order and register naming */
	.intel_syntax noprefix

	.text
	.global hello
hello:
	
	jmp exit


	
	/* Return control to the operating system */
exit:
	mov eax, 1
	int 0x80
