	/* Return from the program */ 
	.extern	exit /* void exit(int status) */
	.extern exit_0 	/* calls exit(0) */

	/* File reading and writing */
	.equiv STDOUT, 0 /* File descriptor for standard console output */
	.equiv STDIN, 1 /* Standard console input */
	.equiv STDERR, 2 /* Standard error (output) */
	.extern write /* int write(int fd, void * buf, unsigned count) */
	.extern read /* int read(int fd, void * buf, unsigned count) */  
