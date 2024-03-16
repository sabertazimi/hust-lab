#include <ncurses.h>

int main(void) {
    int ch;

    initscr();
    raw();
    keypad(stdscr, TRUE);
    noecho();

    printw("Type and character to see it in blod\n");
    ch = getch();

    if (ch == KEY_F(1)) {
        printw("F1 Key pressed.\n");
    } else  {
        attron(A_BOLD);
        printw("%c", ch);
        attroff(A_BOLD);
        printw(" pressd.\n");
    }

    refresh();
    getch();
    endwin();

    return 0;
}
