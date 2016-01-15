#include <stdio.h>
#include <stdlib.h>
#include <time.h>

/***********************************
* @function adjust heap to small top heap
* @param    arr - pointer to heap root 
* @param    m - node to be adjusted
* @param    n - heap size
************************************/
void heap_adjust(int *arr, int m, int n)
{
    int i;

    arr[0] = arr[m];

    for(i=2*m; i<=n; i*=2)
    {   //select max of child
        if(i<n && arr[i]>arr[i+1])
        { 
            i++;
        }
        //adjustment finished
        if(arr[0]<=arr[i])
        {
            break;
        }
        //parent sink
        arr[m] = arr[i];
        //update parent,towards to leaf
        m = i;
    }
    //sink to correct position
    arr[m] = arr[0];
}


void heap_sort(int *arr, int arrsize)
{
    int i, tmp;

    //establish small top heap
    for(i=arrsize/2; i>0; i--)
    {
        heap_adjust(arr, i, arrsize);
    }

    //exchange top node and least leaf node,make a diminishing sort
    for(i=arrsize; i>1; i--)
    {
        tmp = arr[1];
        arr[1] = arr[i];
        arr[i] = tmp;

        heap_adjust(arr, 1, i-1);
    }
}

int main(void)
{
    int arr[10]={0,4,2,5,1,8,7,9};
    int arrsize=7;
    int i;

    printf("Quick Sort:\n");

    heap_sort(arr,arrsize);

    printf("Sorted array: ");
    for(i=1;i<=arrsize;i++)
    {
        printf("%d ",arr[i]);
    }
    printf("\n");
    return 0;
} 
