#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
typedef long long LL;
int main(int argc, char *argv[])
{
    char str[20];
    int n, flag = 1;
    scanf("%d", &n);
    for (int i = 0; i < n; i++)
    {
        scanf(" %c", &str[i]);
    }
    for (int i = 0; i < n / 2; i++)
    {
        if (str[i] == str[n - 1 - i])
            flag = 1;
        else
        {
            flag = 0;
            break;
        }
    }
    printf("%d", flag);
    return 0;
}
