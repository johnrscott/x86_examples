
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
print_word:
	mov $read_buf, %r10
0:	cmp $answer-1, %r10
	je 1f
	mov (%r10), %edi
	cmp 6(%r10), %dil
	jne 2f
	mov $GREEN, %esi
	jmp 3f
2:	mov $RED, %esi
3:	call putchar
	inc %r10
	jmp 0b
1:	PUTCHAR '\n', BLUE
	ret
	
_start:
	xor %r9, %r9
0:	cmp $5, %r9 /* only allow 5 guesses */
	je exit
	call read_line /* read guess into read_buf */
	call print_word
	inc %r9
	jmp 0b
exit:	EXIT 0
	
