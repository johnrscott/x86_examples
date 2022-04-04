
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

	/* Print colour-coded letters */
print:
	mov $read_buf, %r10
	mov $temp, %r11
begin:	cmp $read_buf+6, %r10
	je 0f
	/* Check if the letter is correctly placed */
equal:	mov (%r10), %dil
	cmp 8(%r10), %dil
	jne search
	mov $GREEN, %esi
	call putchar
	jmp end
	/* If not, check if the letter is present anywhere */
search:	cmp (%r11), %dil
	je hit
	inc %r11
	jmp search
miss:	mov $RED, %esi
	jmp end
	/* If found, remove the letter from the temp buffer */
hit:	mov $ORANGE, %esi
	call putchar
	movb $'.', (%r11)
end:	inc %r10
	jmp begin 

0:	ret
	
	
	/* Copy the answer to a temporary buffer */
copy:
	mov answer, %r10
	mov %r10, temp
	ret

	/* Remove correctly placed letters from temp */
remove:
	mov $read_buf, %r10
0:	cmp $read_buf+5, %r10
	je 1f
	mov (%r10), %dil
	cmp 16(%r10), %dil
	jne 2f
	movb $'.', 16(%r10) 
2:	inc %r10
	jmp 0b
1:	ret
	
_start:
	xor %r9, %r9
0:	cmp $5, %r9 /* only allow 5 guesses */
	je exit
	call read /* read guess into read_buf */
	call copy
	call remove
	call print
	inc %r9
	jmp 0b
exit:	EXIT 0
	
