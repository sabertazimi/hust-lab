/*************************************************************************
    > File Name: Heap.h
    > Author: CS1409 U201414800 Yilong Liu 
    > Mail: hustlyl@163.com 
    > Website: sabertazimi.github.io
    > Created Time: 2016年01月15日 星期五 20时09分20秒
 ************************************************************************/

#include <assert.h>
#include "Heap.h"

//open assertion
#undef NDEBUG

int main(void) {
    FILE * fp;
    Time tm = getCurrentTime();
    if ((fp = fopen("simulation.log", "at+")) == NULL) exit(INFEASIBLE);
    showCurrentTime(fp , tm);
    // PatientQueue pq;
    // InitPriorityQue(pq);
    // HeapSort(pq);
    // printf ( "\007The current date/time is: %s", asctime (timeinfo) );
    //    printf ( "\007The current date/time is: %s", asctime (timeinfo) );
    // Print(PATIENTS, )
    return 0;
} 