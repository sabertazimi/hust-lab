/*************************************************************************
    > File Name: PriorityQueue.c
    > Author: CS1409 U201414800 Yilong Liu 
    > Mail: hustlyl@163.com 
    > Website: sabertazimi.github.io
    > Created Time: 2016年01月15日 星期五 19时17分34秒
 ************************************************************************/

#include "PriorityQueue.h"

/********** Function for manage priority **********/

 Status InitPriorityQue(PatientQueue pq) {
    //start initialization
    pq.queue = (Patient * ) malloc (sizeof(Patient) * INIT_PATIENTS);
    pq.queueSize = 0;
    pq.queueMaxSize = INIT_PATIENTS;
    pq.treatedNumber = 0;
    pq.totalNumber = 0;
    pq.treatingStartTime = 0.0;
    pq.treatingLength = 0.0;
    pq.treatingOverTime = 0.0;
    pq.isTreating = FALSE;
    return OK;
 }

 Status DestroyPriorityQue(PatientQueue pq) {
    InitPriorityQue(pq);
    pq.queue = NULL;
    pq.queueMaxSize = 0;
    free(&pq);
    return OK;
 }

 Status ClearPriorityQue(PatientQueue pq) {
    InitPriorityQueue(pq);
    return OK;
 }

 int PriorityQueSize(PatientQueue pq) {
    return pq.queueSize;
 }

 Status PriorityQueInsert(PatientQueue pq, Patient patient) {
    //full check
    if (PriorityQueFull(pq) == TRUE) {
        pq.queue = (Patient * )realloc(sizeof(Patient) * (pq.queueMaxSize + INCREASE_PATIENTS));
        //malloc failure check
        if (pq.queue == NULL) return ERROR
        pq.queueMaxSize += INCREASE_PATIENTS;
    }
    //insert patient
    pq.queue[pq.queueSize] = patient;
    //update other information
    pq.queueSize++;
    pq.totalNumber++;
    //Sort queue
    HeapSort(pq);
    return OK;
 }

/**
 * delete patient  who has highest priority
 * @param  pq  patient queue
 * @return  deleted patient 
 */
Status PriorityQueDeletMax(PatientQueue pq, Patient * patient) {
    //empty check
    if (PriorityQueEmpty(pq) == TRUE) return ERROR;
    //busy state check : if doctor (pq.isTreating == TRUE) is busy, 
    //you can't delete current patient (delete patient means that he/she is to be treated)
    if (pq.isTreating == TRUE) return ERROR;
    //else, delete the first empty
    *patient = pq.queue[0];
    //represent that this patient is to be treated
    for (int i = 1; i < pq.queueSize;i++) {
    	pq.queue[i - 1] = pq.queue[i];
    }
    //update other information
    pq.queueSize--;
    pq.treatedNumber++;
    //syncronize time settings and information
    pq.treatingStartTime = getCurrentTime();
    pq.treatingLength = patient->treatingLength;
    pq.treatingOverTime = pq.treatingStartTime + pq.treatingLength;
    //update busy state
    pq.isTreating = TRUE;
    //Sort queue
    HeapSort(pq);
    return  OK;
 }

/**
 * check patient queue whether empty or not
 * @param  pq  patient queue
 * @return   function status:TRUE/FALSE
 */
 Status PriorityQueEmpty(PatientQueue pq) {
    return pq.queueSize == 0 ? TRUE : FALSE;
 }

/**
 * check patient queue whether full or not
 * @param  pq  patient queue
 * @return   function status:TRUE/FALSE
 */
 Status PriorityQueFull(PatientQueue pq) {
    return pq.queueSize == pq.queueMaxSize ? TRUE : FALSE;
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
 Time SimulateTreatingLength(SickType st) {
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
    fprintf(stdout, "[Current Time - ");
    fprintf(stdout, "%02d:", hour);
    fprintf(stdout, "%02d]", min);
    //fprintf into log file
    fprintf(fp, "[Current Time - ");
    fprintf(fp, "%02d:", hour);
    fprintf(fp, "%02d]", min);

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
