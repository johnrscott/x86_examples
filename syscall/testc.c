#include "syscall.h"

int main()
{
    char buf[20];
    write(STDOUT, "Write some text and press enter: ", 33);
    int count = read(STDIN, &buf, 20);
    write(STDOUT, "You wrote: ", 11);
    write(STDOUT, buf, count);
    exit(3);
}
