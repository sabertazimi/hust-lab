#include <ncurses.h>

int main(void) {
    initscr();
    printw("Welcome to mim text editor\n");
    refresh();
    getch();
    endwin();

    return 0;
}
