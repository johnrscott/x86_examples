/**
 * \file syscall.h
 * \brief Simple library of linux system calls
 *
 */

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

/// Define null pointer
#define NULL 0

/** 
 * \brief Write count characters to file descriptor fd from buffer buf 
 *
 * Both read and write appear to have the same effect for all three file
 * descriptors STDIN, STDOUT and STDERR.
 */
int write(int fd, void * buf, unsigned count);

/**
 * \brief Read count characters from file descriptor fd into buffer buf
 *
 */ 
int read(int fd, void * buf, unsigned count);

struct timespec
{
    long tv_sec;
    long tv_nsec;
};

/**
 * \brief Sleep for a specified number of seconds and nanoseconds
 */
int nanosleep(const struct timespec * rec, struct timespec * rem);

/**
 * \brief Set properties of an input/output device
 */
int ioctl(int fd, unsigned long cmd, void * buf);

// Commands
#define TCGETS 0x5401
#define TCSETS 0x5402

// Local modes
#define ICANON 0x0002
#define ECHO 0x0008
struct termios
{
    int c_iflag; ///< input modes
    int c_oflag; ///< output modes
    int c_cflag; ///< control modes
    int c_lflag; ///< local modes
    char c_cc[8];
};

/**
 * \brief Get a certain number of random bytes
 */
int getrandom(void * buf, long unsigned buflen, unsigned int flags);


#endif
