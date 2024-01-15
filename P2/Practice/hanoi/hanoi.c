
#include <stdio.h>

void hanoi(int n, char from, char via, char to);
void move(int n, char from, char to);

int main(void) {
    int n;
    char from, via, to;
    scanf(" %c %c %c %d", &from, &via, &to, &n);
    hanoi(n, from, via, to);
    return 0;
}

void hanoi(int n, char from, char via, char to) {
    if (1 == n) {
        move(n, from, to);
        return;
    }
    hanoi(n - 1, from, to, via);
    move(n, from, to);
    hanoi(n - 1, via, from, to);
}

void move(int n, char from, char to) {
    printf("Move disk %02d from the %c pole to the %c pole\n", n, from, to);
}
