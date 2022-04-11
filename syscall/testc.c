#include "syscall.h"

int main()
{
    write(0, "Write some text and press enter: ", 33);
    exit(3);
}
