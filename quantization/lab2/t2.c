#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>

int main(void ) {
    struct timeval t1, t2;
    double timeuse;
    int i, j;
    int sizes[18];

    for(i = 0; i < 18; i ++)
    {
        sizes[i] = (1 << i) << 10;                  //计算出1k, 2k, 4k, ... , 128M的数值大小
    }

    for(i = 0; i < 18; i ++)
    {
        int size = sizes[i];
        char *data = (char *)malloc(size * sizeof(char));   //分配对应大小的空间
        memset(data, 1, size);                      //将内容设置为1

        int result = 0;

        gettimeofday(&t1, NULL);                    //计时开始

        for(j = 0; j < (1 << 25); j++)                  //访问2^25次
        {
            result += data[((long long)1023* (j % size)) % size];                  //以127为步长访问
        }

        gettimeofday(&t2, NULL);                    //计时结束
        timeuse = t2.tv_sec - t1.tv_sec
            + (t2.tv_usec - t1.tv_usec)/1000000.0;      //计算时长

        printf("%dK, %fsecs, result:%d\n",
        size / 1024, timeuse, result);              //打印结果
    }

    return 0;
}
