	.include "syscall.inc"

	.data
buf1:	.ascii "Write some text and press enter: "
buf2:	.ascii "You wrote: "
buf3:	.space 20
buf4:	.ascii "Sleep\n"
buf5:	.ascii "Done\n"

ts_time:
	.int 0,0
	.int 250000000, 0 /* 250 milliseconds */
	
	.text
	.global _start
_start:
	/* write(STDOUT, "Write some text and press enter: ", 33); */
	mov $STDOUT, %rdi
	mov $buf1, %rsi
	mov $33, %rdx
	call write
	/* int count = read(STDIN, &buf3, 20); */
	mov $STDIN, %rdi
	mov $buf3, %rsi	
	call read
	mov %rax, %r12 /* Save count in r12, preserved across calls */
	/* write(STDOUT, "You wrote: ", 11); */
	mov $STDOUT, %rdi
	mov $buf2, %rsi
	mov $11, %rdx
	call write
	/* write(STDOUT, $buf3 , count); */
	mov $STDOUT, %rdi
	mov $buf3, %rsi
	mov %r12, %rdx
	call write
	/* for (int n = 0; n < 5; n++) { */
	xor %r12, %r12	
0:      /* write(STDOUT, &buf4, 6); */
	mov $STDOUT, %rdi
	mov $buf4, %rsi
	mov $6, %rdx
	call write
	/* nanosleep(&ts_time, NULL); */
	mov $ts_time, %rdi
	xor %rsi,%rsi
	call nanosleep
	inc %r12
	cmp $5, %r12
	jne 0b
	/* } */
	/* write(STDOUT, &buf5, 5); */
	mov $STDOUT, %rdi
	mov $buf5, %rsi
	mov $5, %rdx
	call write
	/* exit(2); */
	mov $2, %rdi
	call exit
