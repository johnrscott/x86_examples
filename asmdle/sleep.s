	.include "syscall.inc"

	.data
ts_time:
	.int 0,0
	.int 100000000, 0 /* Sleep time, nanoseconds */

	.text

	/* void sleep_short() */
	.global sleep_short
sleep_short:
	/* nanosleep(&ts_time, NULL); */
	mov $ts_time, %rdi
	xor %rsi, %rsi
	call nanosleep
	ret
	
	/* void sleep_medium() */
	.global sleep_medium
sleep_medium:
	call sleep_short
	call sleep_short
	ret

	/* void sleep_medium() */
	.global sleep_long
sleep_long:
	call sleep_medium
	call sleep_medium
	call sleep_medium
	call sleep_medium
	ret

	
