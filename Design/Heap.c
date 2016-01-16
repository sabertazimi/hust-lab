/*************************************************************************
    > File Name: Heap.h
    > Author: CS1409 U201414800 Yilong Liu 
    > Mail: hustlyl@163.com 
    > Website: sabertazimi.github.io
    > Created Time: 2016年01月15日 星期五 19时17分34秒
 ************************************************************************/

#include "Heap.h"

/********** Function for manage priority **********/

/**
 * Initialize patient queue
 * @param  pq  patient queue
 * @return   function status:OK/ERROR 
 */
 Status InitPriorityQue(PatientQueue pq) {
    return OK;
 }

/**
 * Destory patient queue
 * @param  pq  patient queue
 * @return   function status:OK/ERROR 
 */
 Status DestroyPriorityQue(PatientQueue pq) {
    return OK;
 }

/**
 * Clear up patient queue
 * @param  pq  patient queue
 * @return   function status:OK/ERROR 
 */
 Status ClearPriorityQue(PatientQueue pq) {
    return OK;
 }

/**
 * get patient queue length
 * @param  pq  patient queue
 * @return   patient queue length 
 */
 int PriorityQueSize(PatientQueue pq) {
    return 0;
 }

/**
 * insert new patient to patient queue
 * @param  pq  patient queue
 * @return   function status:OK/ERROR 
 */
 Status PriorityQueInsert(PatientQueue pq) {
    return OK;
 }

/**
 * delete patient  who has highest priority
 * @param  pq  patient queue
 * @return  deleted patient 
 */
 Patient PriorityQueDeletMax(PatientQueue pq) {
    return ;
 }

/**
 * check patient queue whether empty or not
 * @param  pq  patient queue
 * @return   function status:TRUE/FALSE
 */
 Status PriorityQueEmpty(PatientQueue pq) {
    return TRUE;
 }

/**
 * check patient queue whether full or not
 * @param  pq  patient queue
 * @return   function status:TRUE/FALSE
 */
 Status PriorityQueFull(PatientQueue pq) {
    return TRUE;
 }

/********** End of  Function for manage priority **********/



/********** Function for heap sort **********/

 Status HeapAdjust(PatientQueue pq, int top, int queueSize) {
    int i;
    Patient tmpTop;
    tmpTop = pq.queue[top];

    //undefine check
    if(pq.queue == NULL ) return ERROR;

    for(i = 2 * top; i <= queueSize; top = i, i *= 2) {   //select max of child
        if(i < queueSize && pq.queue[i].priority > pq.queue[i+1].priority) { 
            i++;
        }
        //adjustment finished
        if(tmpTop.priority <= pq.queue[i].priority) {
            break;
        }
        //parent sink
        pq.queue[top] = pq.queue[i];
    }
    //sink to correct position
    pq.queue[i] = tmpTop;
    return OK;
}


Status HeapSort(PatientQueue pq) {
    int i;
    Patient tmp;
    //undefine check and empty check
    if(pq.queue == NULL || PriorityQueEmpty(pq) == TRUE) return ERROR; 

    //establish small top heap
    for(i = pq.queueSize / 2; i > 0; i--) {
        HeapAdjust(pq, i, pq.queueSize);
    }

    //exchange top node and least leaf node,make a diminishing sort
    for(i = pq.queueSize; i > 1; i--) {
        tmp = pq.queue[1];
        pq.queue[1] = pq.queue[i];
        pq.queue[i] = tmp;
        HeapAdjust(pq, 1, i - 1);
    }

    return OK;
}

/********** End of Function for heap sort **********/



/********** Function for simulation hospital**********/

 /**
 * according to sicktype,simulate and evaluate treatingLength
 * @param  st  sick types
 * @return        treating length
 */
 Time getTreatingLength(SickType st) {
    return 0.0;
 }

 Time getCurrentTime() {
    time_t rawtime;
    struct tm * timeinfo;
    Time currentTime;
    time ( &rawtime );                            //get system time
    timeinfo = localtime ( &rawtime );//convert to local time 
    // tm_hour, tm_min
    currentTime = (float) (timeinfo->tm_hour + timeinfo->tm_min * 0.01);
    return currentTime;
}

/**
 * log current system time to target file and stand outputstream
 * @param  fp [description]
 * @return    [description]
 */
Status showCurrentTime(FILE * fp, Time tm) { 
    int hour,min;
    //undefined check
    if (fp == NULL) return ERROR;
    //show time
    hour = (int) tm;
    min = (int) ((tm - hour) * 100);
    //printf on screnn
    printf("[Current Time - ");
    printf("%02d:", hour);
    printf("%02d ]", min);
    //fprintf into log file
    fprintf(fp, "[Current Time - ");
    fprintf(fp, "%02d:", hour);
    fprintf(fp, "%02d ]", min);

    //return
    return OK;
}

/********** End of Function for simulation hospital**********/



/********** Function for log(Test) and print(UI)**********/

 /**   
 * log runtime information of this simulation program
 * @param  lt            log type : according to it,log correct information
 * @param  fp            file pointer : log into this file 
 * @param  systemTime show current time 
 * @param  pq                  patient queue:get enough information        
 * @return   function status:OK/ERROR 
 */
 Status Log(LogType lt, FILE * fp, Time systemTime, PatientQueue pq) {
    return OK;
 }

 /**   
 * print runtime information of this simulation program on screen 
 * @param  lt            log type : according to it,print correct information
 * @param  systemTime show current time 
 * @param  pq                  patient queue:get enough information        
 * @return   function status:OK/ERROR 
 */
 Status Print(LogType lt, Time systemTime, PatientQueue pq) {
    return OK;
 }

/********** End of Function for log(Test) and print(UI)**********/
