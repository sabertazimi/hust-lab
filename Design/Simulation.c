/*************************************************************************
    > File Name: Simulation.c 
    > Author: CS1409 U201414800 Yilong Liu 
    > Mail: hustlyl@163.com 
    > Website: sabertazimi.github.io
    > Created Time: 2016年01月15日 星期五 20时09分20秒
 ************************************************************************/

#include "PriorityQueue.h"

//open assertion
#undef NDEBUG

int main(void) {
    FILE *fp;
    Patient patient;
    Patient *pPatient = (Patient *) malloc(sizeof(Patient));
    PatientQueue pq;
    pq.queue = NULL;
    //man made delta time clock
    Time lastTimeNode = GetCurrentTime();
    Time currentTimeNode = lastTimeNode + GLOBAL_INTERVAL_TIME + 0.001;
    Time lastInsertTimeNode = GetCurrentTime();
    Time currentInsertTimeNode = lastInsertTimeNode + INSERT_INTERVAL_TIME + 0.001;
    //simulation length
    Time startTime = GetCurrentTime();
    //open log file
    if ((fp = fopen("Simulation.log", "at+")) == NULL) exit(INFEASIBLE);
    //initlization
    InitPriorityQue(&pq);
    //start simulation
    //Simulation Loop
    while (pq.queueMaxSize < OVER_MAX_SIZE && GetCurrentTime() - startTime < SIMULATION_LENGTH) {
        if (currentTimeNode - lastTimeNode >= GLOBAL_INTERVAL_TIME) {
            //update lastTImeNode
            lastTimeNode = GetCurrentTime();
            //refresh patients' queue
            ChangeBusyState(&pq);
            RemoveLeavedPatients(&pq, fp);
            RefreshPriority(&pq);
            HeapSort(&pq);
            //check whether the past INSERT_INTERVAL_TIME time
            if (currentInsertTimeNode - lastInsertTimeNode >= INSERT_INTERVAL_TIME) {
                lastInsertTimeNode = GetCurrentTime();
                //insert new patient into queue
                patient = NewPatient();
                if (PriorityQueInsert(&pq, patient) == OK) {
                    Log(ARRIVED, fp, pq, patient);
                }
            }
            //check whether doctor is busy
            if (pq.isTreating == FALSE) {
                if (PriorityQueDeletMax(&pq, pPatient) == OK) {
                    Log(TREATED, fp, pq, *pPatient);
                    Log(QUEUE, fp, pq, *pPatient);
                }
            }
        } //end of if (currentTimeNode - lastTimeNode >= GLOBAL_INTERVAL_TIME)
        currentTimeNode = GetCurrentTime();
        currentInsertTimeNode = GetCurrentTime();
    }
    DestroyPriorityQue(&pq);
    return 0;
} 