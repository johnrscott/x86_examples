#include "syscall.h"
#include <stdio.h>

int main()
{
    char buf[20];
    struct timespec ts_time = { .tv_sec = 0, .tv_nsec = 250000000 }; 

    struct termios buf2;
    struct termios buf3;
    
    write(STDOUT, "Write some text and press enter: ", 33);
    int count = read(STDIN, &buf, 20);
    write(STDOUT, "You wrote: ", 11);
    write(STDOUT, buf, count);
    for (int n = 0; n < 5; n++) {
	nanosleep(&ts_time, NULL);
	write(STDOUT, "Sleep\n", 6);
    }
    write(STDOUT, "Done\n", 5);

    ioctl(STDIN,TCGETS,&buf2);
    buf3 = buf2;
    buf3.c_lflag &= (~ICANON & ~ECHO);
    ioctl(STDIN,TCSETS,&buf3);

    for (int n = 0; n < 100; n++) {
	char c;
	char cr = '\r';
	read(STDIN, &c, 1);
	if (c == 10) {
	    write(STDOUT, &cr, 1);
	} else {
	    write(STDOUT, &c, 1);
	}
    }

    ioctl(STDIN,TCSETS,&buf2); // Reset    
    exit(3);
}
