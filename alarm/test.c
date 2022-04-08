#include <signal.h>
#include <stdio.h>

int main()
{
    printf("%ld", sizeof(sigset_t));
}
