#ifndef SYSCALL_H
#define SYSCALL_H

/// Exit the program with status code
void exit(int status);

/// Helper to call exit(0)
void exit_0();

/// Standard file descriptors
#define STDIN 0
#define STDOUT 1
#define STDERR 2

/// Write count characters to file descriptor fd from buffer buf 
int write(int fd, void * buf, unsigned count);

/// Read count characters from file descriptor fd into buffer buf 
int read(int fd, void * buf, unsigned count);

#endif
