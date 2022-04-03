
	.global _start

	
	/* Exit program with code; use: "EXIT code". */
	.macro EXIT code
	mov $\code, %ebx
	mov $1, %eax
	int $0x80
	.endm
	
	.equ RED, '1'	
	.equ GREEN, '2'
	.equ ORANGE, '3'
	.equ BLUE, '4'
	.equ PURPLE, '5'
	.equ CYAN, '6'

	.macro PUTCHAR char, colour
	mov $\char, %edi
	mov $\colour, %esi
	call putchar	
	.endm

	.data
col_buf:
	.space 5, BLUE
		
	.text

	/* Print the word in colours depending on whether
	the letters are in the answer or not. Letters are printed
	red if they are not in the answer, orange if they are not
	in the correct position, and green if they are in the
	right position. The function expects the test word to
	be in the read_buf.
	*/
print:
	mov $read_buf, %r10
0:	cmp $read_buf+5, %r10
	je end
	mov (%r10), %edi /* Get current letter of read_buf */
	mov $temp, %r11
search:	cmp (%r11), %dil
	je found
missed:	inc %r11
	cmp $temp+6, %r11
	jne search
wrong:	mov $RED, %esi
	jmp output

found:	movb $'.', (%r11)
	sub $16, %r11
	cmp %r11, %r10
	jne orange
green:	mov $GREEN, %esi
	jmp output
	
orange:	mov $ORANGE, %esi
output:	call putchar
	inc %r10
	jmp 0b
end:	PUTCHAR '\n', BLUE
	ret

copy:
	mov answer, %r11
	mov %r11, temp
	ret
	
_start:
	xor %r9, %r9
0:	cmp $5, %r9 /* only allow 5 guesses */
	je exit
	call read /* read guess into read_buf */
	call copy
	call print
	inc %r9
	jmp 0b
exit:	EXIT 0
	
