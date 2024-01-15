#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
typedef long long LL;

int n, a[100][100], b[100][100], ans[100][100];
int main(int argc, char *argv[])
{
    scanf("%d", &n);
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < n; j++)
        {
            scanf("%d", &a[i][j]);
        }
    }
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < n; j++)
        {
            scanf("%d", &b[i][j]);
        }
    }

    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < n; j++)
        {
            int sum=0;
            for (int k = 0; k < n; k++)
                sum += a[i][k] * b[k][j];
            printf("%d ", sum);
        }
        printf("\n");
    }
    return 0;
}
