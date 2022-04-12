#include "syscall.h"

int main()
{
    char buf[20];
    struct timespec ts_time = { .tv_sec = 0, .tv_nsec = 250000000 }; 
    
    write(STDOUT, "Write some text and press enter: ", 33);
    int count = read(STDIN, &buf, 20);
    write(STDOUT, "You wrote: ", 11);
    write(STDOUT, buf, count);
    for (int n = 0; n < 5; n++) {
	nanosleep(&ts_time, NULL);
	write(STDOUT, "Sleep\n", 6);
    }
    write(STDOUT, "Done\n", 5);
	
    
    exit(3);
}
