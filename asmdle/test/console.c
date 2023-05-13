#include <termios.h>
#include <unistd.h>
#include <stdio.h>


int main() {
    char c;
    char p = '*';
    struct termios term, original;
    tcgetattr(STDIN_FILENO, &term);
    original = term;
    term.c_lflag &= ~ECHO & ~ICANON;
    tcsetattr(STDIN_FILENO, TCSANOW, &term);

    while (read(STDIN_FILENO, &c, 1) == 1 && c != '\n')
        write(STDOUT_FILENO, &p, 1);
    printf("\n");

    tcsetattr(STDIN_FILENO, TCSANOW, &original);
    return 0;
}
