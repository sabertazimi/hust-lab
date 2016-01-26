/*************************************************************************
    > File Name: PriorityQueue.c
    > Author: CS1409 U201414800 Yilong Liu 
    > Mail: hustlyl@163.com 
    > Website: https://github.com/sabertazimi/DataStructureLab/tree/master/Design 
    > Created Time: 2016年01月15日 星期五 19时17分34秒
 ************************************************************************/

#include "PriorityQueue.h"

/********** Function for manage priority **********/

Status InitPriorityQue(PatientQueue *pq) {
    //start initialization
    pq->queue = (Patient *) malloc(sizeof(Patient) * INIT_PATIENTS);
    pq->queueSize = 0;
    pq->queueMaxSize = INIT_PATIENTS;
    pq->treatedNumber = 0;
    pq->totalNumber = 0;
    pq->treatingStartTime = 0.0;
    pq->treatingLength = 0.0;
    pq->treatingOverTime = 0.0;
    pq->isTreating = FALSE;
    return OK;
}

Status DestroyPriorityQue(PatientQueue *pq) {
    InitPriorityQue(pq);
    pq->queue = NULL;
    pq->queueMaxSize = 0;
    return OK;
}

Status ClearPriorityQue(PatientQueue *pq) {
    InitPriorityQue(pq);
    return OK;
}

int PriorityQueSize(PatientQueue pq) {
    return pq.queueSize;
}

Status PriorityQueInsert(PatientQueue *pq, Patient patient) {
    //full check
    if (PriorityQueFull(*pq) == TRUE) {
        pq->queue = (Patient *) realloc(pq->queue, sizeof(Patient) * (pq->queueMaxSize + INCREASE_PATIENTS));
        //malloc failure check
        if (pq->queue == NULL) return ERROR;
        pq->queueMaxSize += INCREASE_PATIENTS;
    }
    //insert patient
    pq->queue[pq->queueSize] = patient;
    //update other information
    pq->queueSize++;
    pq->totalNumber++;
    //Sort queue
    HeapSort(pq);
    return OK;
}

Status PriorityQueDeletMax(PatientQueue *pq, Patient *patient) {
    //empty check
    if (PriorityQueEmpty(*pq) == TRUE) return ERROR;
    //busy state check : if doctor (pq.isTreating == TRUE) is busy, 
    //you can't delete current patient (delete patient means that he/she is to be treated)
    if (pq->isTreating == TRUE) return ERROR;
    //else, delete the first empty
    *patient = pq->queue[0];
    //represent that this patient is to be treated
    for (int i = 1; i < pq->queueSize; i++) {
        pq->queue[i - 1] = pq->queue[i];
    }
    //update other information
    pq->queueSize--;
    pq->treatedNumber++;
    //syncronize time settings and information
    pq->treatingStartTime = GetCurrentTime();
    pq->treatingLength = patient->treatingLength;
    pq->treatingOverTime = pq->treatingStartTime + pq->treatingLength;
    //update busy state
    pq->isTreating = TRUE;
    //Sort queue
    HeapSort(pq);
    return OK;
}

Status PriorityQueEmpty(PatientQueue pq) {
    return pq.queueSize == 0 ? TRUE : FALSE;
}

Status PriorityQueFull(PatientQueue pq) {
    return pq.queueSize == pq.queueMaxSize ? TRUE : FALSE;
}

/********** End of  Function for manage priority **********/



/********** Function for heap sort **********/

Status HeapAdjust(PatientQueue *pq, int top, int queueSize) {
    int i;
    Patient tmpTop = pq->queue[top];

    //undefine check
    if (pq->queue == NULL) return ERROR;

    for (i = 2 * top + 1; i < queueSize; top = i, i = 2 * i + 1) {   //select max of child
        if (i + 1 < queueSize && pq->queue[i].priority > pq->queue[i + 1].priority) {
            i++;
        }
        //adjustment finished
        if (tmpTop.priority <= pq->queue[i].priority) {
            break;
        }
        //parent sink
        pq->queue[top] = pq->queue[i];
    }
    //sink to correct position
    pq->queue[top] = tmpTop;
    return OK;
}

Status HeapSort(PatientQueue *pq) {
    int i;
    Patient tmp;
    //undefine check and empty check
    if (pq->queue == NULL || PriorityQueEmpty(*pq) == TRUE) return ERROR;

    //establish small top heap
    for (i = (int) ((pq->queueSize - 1) / 2); i >= 0; i--) {
        HeapAdjust(pq, i, pq->queueSize);
    }

    //exchange top node and least leaf node,make a diminishing sort
    for (i = pq->queueSize - 1; i > 0; i--) {
        tmp = pq->queue[0];
        pq->queue[0] = pq->queue[i];
        pq->queue[i] = tmp;
        HeapAdjust(pq, 0, i);
    }

    return OK;
}

/********** End of Function for heap sort **********/



/********** Function for simulation hospital**********/

Priority CalculatePriority(Patient patient) {
    Time tm = GetCurrentTime();
    //calculate priority : most important factor is arrive time
    //the eariler patient arrive, the higher priority patient can occupy
    Priority priority = (24 - patient.arrivedTime) * ARRIVE_TIME_RATE
                        + 100 * patient.treatingLength * (100 - ARRIVE_TIME_RATE) / 2
                        - (patient.leavingTime - tm) * (100 - ARRIVE_TIME_RATE) / 2;
    return priority;
}

Time SimulateTreatingLength(SickType st) {
    Time treatingLength;
    //initialize random number emmiter
    srand((unsigned int) time(NULL));
    //emmit a random number locate on [-2, 2]
    int randNum = -2 + rand() % 5;
    //according to sick type, calculate treating length
    switch (st) {
        case HEALTHY:
            treatingLength = 1;
            break;
        case NORMAL:
            treatingLength = NORMAL * 2 + randNum + 1;
            break;
        case ACUTE:
            treatingLength = ACUTE * 2 + randNum;
            break;
        case CHRONIC:
            treatingLength = CHRONIC * 2 + randNum;
            break;
        case INFLAMMATION:
            treatingLength = INFLAMMATION * 2 + randNum;
            break;
        case RELAPSE:
            treatingLength = RELAPSE * 2 + randNum;
            break;
    }
    return 0.01 * treatingLength;
}

Patient NewPatient() {
    Patient patient;
    //initialize random number emmiter
    srand((unsigned int) time(NULL));
    //emmit a random number locate on [0, 5]
    //set it as new patient's sick type
    SickType sickType = (SickType) (rand() % 6);
    //emmit a random number locate on [0, 30] min
    //set it as new patient's possible waiting time : 0 ~0.5 hour
    Time waitingTime = (Time) (rand() % 31);
    waitingTime *= 0.01;
    //initialize patient
    patient.arrivedTime = GetCurrentTime();
    patient.treatingLength = SimulateTreatingLength(sickType);
    patient.leavingTime = patient.arrivedTime + waitingTime;
    patient.sickType = sickType;
    patient.priority = CalculatePriority(patient);
    //done
    return patient;
}

Time GetCurrentTime() {
    time_t rawtime;
    struct tm *timeinfo;
    Time currentTime;
    time(&rawtime);                            //get system time
    timeinfo = localtime(&rawtime);//convert to local time
    // tm_hour, tm_min, tm_sec
    currentTime = (float) (timeinfo->tm_hour + timeinfo->tm_min * 0.01 + timeinfo->tm_sec * 0.0001);
    return currentTime;
}

Status ShowTime(FILE *fp, Time tm) {
    int hour, min, sec;
    //undefined check
    if (fp == NULL) return ERROR;
    //show time
    hour = (int) tm;
    min = (int) ((tm - hour) * 100);
    sec = (int) ((tm - hour - min * 0.01) * 10000);
    //check sec > 60, make a carry
    if (sec >= 60) {
        min++;
        sec = sec - 60;
    }
    //check min > 60 , make a carry
    if (min >= 60) {
        hour++;
        min = min - 60;
    }
    //printf on screnn
    fprintf(stdout, "%02d:", hour);
    fprintf(stdout, "%02d:", min);
    fprintf(stdout, "%02d", sec);
    //fprintf into log file
    fprintf(fp, "%02d:", hour);
    fprintf(fp, "%02d:", min);
    fprintf(fp, "%02d", sec);

    //return
    return OK;
}

Status ChangeBusyState(PatientQueue *pq) {
    //undefine check
    if (pq->queue == NULL) return ERROR;
    //last patient's treatment is over
    if (pq->treatingOverTime < GetCurrentTime()) {
        //change busy state
        pq->isTreating = FALSE;
    }
    return OK;
}

Status RemoveLeavedPatients(PatientQueue *pq, FILE *fp) {
    //undefine check
    if (pq->queue == NULL) return ERROR;
    //remove patients have left
    for (int i = 0; i < pq->queueSize; i++) {
        if (pq->queue[i].leavingTime < GetCurrentTime()) {
            //RemoveLeavedPatients
            //log
            Log(LEAVED, fp, *pq, pq->queue[i]);
            //shift
            for (int j = i + 1; j < pq->queueSize; j++) {
                pq->queue[j - 1] = pq->queue[j];
            } //end of for j

            pq->queueSize--;
        }  //end of if
    }  //end of for i
    return OK;
}

Status RefreshPriority(PatientQueue *pq) {
    //undefine check
    if (pq->queue == NULL) return ERROR;
    //refresh patients' priority
    for (int i = 0; i < pq->queueSize; i++) {
        pq->queue[i].priority = CalculatePriority(pq->queue[i]);
    }
    //done
    return OK;
}

/********** End of Function for simulation hospital**********/



/********** Function for log(Test) and print(UI)**********/

Status PrintPatientInfo(FILE *fp, Patient patient) {
    fprintf(stdout, "[Patient:Arrive - ");
    fprintf(fp, "[Patient:Arrive - ");
    ShowTime(fp, patient.arrivedTime);
    fprintf(stdout, "  Treatment Length - ");
    fprintf(fp, "  Treatment Length - ");
    ShowTime(fp, patient.treatingLength);
    fprintf(stdout, "  Leave - ");
    fprintf(fp, "  Leave - ");
    ShowTime(fp, patient.leavingTime);
    fprintf(stdout, "  Priority - %.2f", patient.priority);
    fprintf(fp, "  Priority - %.2f", patient.priority);
    fprintf(stdout, "]\n");
    fprintf(fp, "]\n");
    return OK;
}

Status PrintQueueInfo(FILE *fp, PatientQueue pq) {
    //undefined check
    if (pq.queue == NULL) return ERROR;
    //print on screen
    fprintf(stdout,
            "[Patient Queue:Waiting Number - %d  Treated Number - %d  Total Number - %d  Treatment Rate %.2f%%]",
            pq.queueSize, pq.treatedNumber, pq.totalNumber,
            1.0 * pq.treatedNumber / pq.totalNumber * 100);
    fprintf(stdout, "\n");
    //log into file
    fprintf(fp, "[Patient Queue:Waiting Number - %d  Treated Number - %d  Total Number - %d  Treatment Rate %.2f%%]",
            pq.queueSize, pq.treatedNumber, pq.totalNumber,
            1.0 * pq.treatedNumber / pq.totalNumber * 100);
    fprintf(fp, "\n");
    //print patients' information
    for(int i = 0;i < pq.queueSize;i++) {
    	fprintf(stdout, "\t\t\t\t");
    	fprintf(fp, "\t\t\t\t");
    	PrintPatientInfo(fp, pq.queue[i]);
    }
    return OK;
}

Status Log(LogType lt, FILE *fp, PatientQueue pq, Patient patient) {
    switch (lt) {
        case ARRIVED:
            //show current system time
            fprintf(stdout, "[Time:");
            fprintf(fp, "[Time:");
            ShowTime(fp, GetCurrentTime());
            fprintf(stdout, "]");
            fprintf(fp, "]");
            //printf arrive patient's information
            fprintf(stdout, "Arrive Events - ");
            fprintf(fp, "Arrive Events - ");
            //log patient's information
            PrintPatientInfo(fp, patient);
            break;
        case TREATED:
            //show current system time
            fprintf(stdout, "[Time:");
            fprintf(fp, "[Time:");
            ShowTime(fp, GetCurrentTime());
            fprintf(stdout, "]");
            fprintf(fp, "]");
            //printf treated patient's information
            fprintf(stdout, "Treat Events  - ");
            fprintf(fp, "Treat Events  - ");
            //log patient's information
            PrintPatientInfo(fp, patient);
            break;
        case LEAVED:
            //show current system time
            fprintf(stdout, "[Time:");
            fprintf(fp, "[Time:");
            ShowTime(fp, GetCurrentTime());
            fprintf(stdout, "]");
            fprintf(fp, "]");
            //printf leave patient's information
            fprintf(stdout, "Leave Events  - ");
            fprintf(fp, "Leave Events  - ");
            //log patient's information
            PrintPatientInfo(fp, patient);
            break;
        case QUEUE:
            //show current system time
            fprintf(stdout, "[Time:");
            fprintf(fp, "[Time:");
            ShowTime(fp, GetCurrentTime());
            fprintf(stdout, "]");
            fprintf(fp, "]");
            fprintf(stdout, "Summarize     - ");
            fprintf(fp, "Summarize     - ");
            //log patients' queue information
            PrintQueueInfo(fp, pq);
            break;
    }
    return OK;
}

/********** End of Function for log(Test) and print(UI)**********/
