#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
typedef long long LL;
int m1, m2, n1, n2;

int matrix_f[11][11];
int matrix_h[11][11];
int main(int argc, char *argv[])
{

    scanf("%d", &m1);
    scanf("%d", &n1);
    scanf("%d", &m2);
    scanf("%d", &n2);

    for (int i = 0; i < m1; i++)
    {
        for (int j = 0; j < n1; j++)
        {
            scanf("%d", &matrix_f[i][j]);
        }
    }
    for (int i = 0; i < m2; i++)
    {
        for (int j = 0; j < n2; j++)
        {
            scanf("%d", &matrix_h[i][j]);
        }
    }
    for (int i = 0; i < m1 - m2 + 1; i++)
    {
        for (int j = 0; j < n1 - n2 + 1; j++)
        {
            int sum = 0;
            for (int k = 0; k < m2; k++)
            {
                for (int l = 0; l < n2; l++)
                {
                    sum += matrix_f[i + k][j + l] * matrix_h[k][l];
                }
            }
            printf("%d ", sum);
        }
        printf("\n");
    }

    return 0;
}
