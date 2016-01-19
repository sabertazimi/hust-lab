/*************************************************************************
	> File Name: PriorityQueue.h
	> Author: CS1409 U201414800 Yilong Liu 
	> Mail: hustlyl@163.com 
              > Website: sabertazimi.github.io
	> Created Time: 2016年01月15日 星期五 18时07分54秒
 ************************************************************************/

#ifndef  _PRIORITY_QUEUE_H
#define _PRIORITY_QUEUE_H

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

//macro
#define TRUE 1
#define FALSE 0
#define OK 1
#define ERROR 0
#define INFEASIBLE -1
#define OVERFLOW -2

//initial number of patients
#define INIT_PATIENTS 100
//increase delta number of patients
#define INCREASE_PATIENTS 50
//variable types
typedef int Status;
typedef int Boolean;
typedef float Time;       //store time
typedef float Priority;  //store patient priority
//different sick types types of sicks identifier
typedef enum __SICKTYPE__ { 
	NORMAL, ACUTE,
	CHRONIC,
	INFLAMMATION,
	RELAPSE
} SickType;

//struct for patient's information
typedef struct Patient {
    Time arrivedTime;     //store time when patient arrived at hospital
    Time treatingLength;//store how long time it will take to visit this patient
    Time leavingTime;     //store time when patient to be leave hospital
    SickType sickType;     //store what type of sick this patient suffered from
                                         //according to types, evaluate and simulate value of 'treatingLength'
    Priority priority;        //store patient priority
} Patient;
//patient priority queue
typedef struct PatientQueue {
    Patient * queue;  	   //patient queue(static array)
    int queueSize;       	   //current number of patient waiting for treating
    int queueMaxSize;	   //current max queue capability
    int treatedNumber;       //store the number of patients who has been treated
    int totalNumber;            //store the number of patients who has visited hospital(maybe not be treated)
    Time treatingStartTime;//store start time of current patient who is being treating
    Time treatingLength;     //store treating length of current patient who is being treating
    Time treatingOverTime;//store over time of current patient who is being treating
    Boolean isTreating;        //show doctor whether busy or not
} PatientQueue;


//different logger types  
//ARRIVED:log when patient arrive at hospital
//TREATED:log when patient are being treated
//LEAVED:log when patient leave hospital
//RATE:log treatment rate
typedef enum __LOGTYPE__ {
	ARRIVED,
	TREATED,
	LEAVED,
	RATE,
	PATIENTS
} LogType;



/********** Function for manage priority **********/

/**
 * Initialize patient queue
 * @param  pq  patient queue
 * @called by - DestoryPriorityQueue
 *                     - ClearPriorityQueue
 * @return   function status:OK/ERROR 
 */
Status InitPriorityQue(PatientQueue pq);

/**
 * Destory patient queue
 * @param  pq  patient queue
 * @call        InitPriorityQueue
 * @return   function status:OK/ERROR 
 */
Status DestroyPriorityQue(PatientQueue pq);

/**
 * Clear up patient queue
 * @param  pq  patient queue
 * @call        InitPriorityQueue
 * @return   function status:OK/ERROR 
 */
Status ClearPriorityQue(PatientQueue pq);

/**
 * get patient queue length
 * @param  pq  patient queue
 * @return   patient queue length 
 */
int PriorityQueSize(PatientQueue pq);

/**
 * insert new patient to patient queue
 * @param  pq  patient queue
 * @param  patient   the patient to be inserted
 * @call       - PriorityQueueFull
                    - Log
                    - Print
                    - HeapSort
 * @return   function status:OK/ERROR 
 */
Status PriorityQueInsert(PatientQueue pq, Patient patient);

/**
 * delete patient  who has highest priority
 * @param  pq          patient queue
 * @param patient   patient deleted(is to be treated) 
 * @call       - PriorityQueueEmpty
                    - Log
                    - Print
                    - HeapSort
                    - getCurrentTime
 * @return  function status : OK/ERROR 
 */
Status PriorityQueDeletMax(PatientQueue pq, Patient * patient);

/**
 * check patient queue whether empty or not
 * @param  pq  patient queue
 * @called by     PriorityQueDeletMax
 * @return   function status:TRUE/FALSE
 */
Status PriorityQueEmpty(PatientQueue pq);

/**
 * check patient queue whether full or not
 * @param  pq  patient queue
 * @called by     PriorityQueueInsert
 * @return   function status:TRUE/FALSE
 */
Status PriorityQueFull(PatientQueue pq);

/********** End of  Function for manage priority **********/



/********** Function for heap sort **********/

/**
* function adjust heap to small top heap
* @param  pq  patient queue
* @param  top from this node, begin adjust heap to small top heap
* @param  queueSize  queue length(number of patient)
* @return   function status:OK/ERROR 
*/
Status HeapAdjust(PatientQueue pq, int top, int queueSize);

/**
* sort patient queue to sorted by priority 
* @param  pq  patient queue
* @called by  - PriorityQueueInsert
*                      - PriorityQueueDeletMax
*                      - RefreshQueue
* @return   function status:OK/ERROR 
*/
Status HeapSort(PatientQueue pq); 

/********** End of Function for heap sort **********/



/********** Function for simulation hospital**********/


/**
 * according current system time, calculate patient's priority
 * @param  patient 
 * @called by   - RefreshPriority
                           - NewPatient
 * @return        patient's priority 
 */
Priority CalculatePriority(Patient patient);



/**
 * randomly construct a patient
 * @call - getCurrentTime
               - CalculatePriority
 * @return new patient 
 */
Patient NewPatient();

 /**
 * according to sicktype,simulate and evaluate treatingLength
 * @param  st  sick types
 * @return        treating length
 */
Time SimulateTreatingLength(SickType st);

/**
 * get current system time
 * @called by   - NewPatient   
 *                       - PriorityQueDeletMax
 *                       - RefreshPriority
 *                       - RemoveLeavedPatients
 * @return  current system time(float)
 */
Time getCurrentTime();

/**
 * log time to target file or stand outputstream
 * @param  fp file pointer to target file
 * @param  tm time(may be not current system time)
 * @called by - Log
 *                     - Print
 * @return   function status:OK/ERROR 
 */
Status showTime(FILE * fp, Time tm);

/**
 * check is there any patient is being treated (pq.isTreating)
 * @param  pq  patient queue
 * @called by - RefreshQueue
 * @return   function status : OK/ERROR 
 */
Status ChangeBusyState(PatientQueue pq);

/**
 * delete patients (have not been treated) who have left hospital
 * @param  pq patient queue
 * @call           - getCurrentTime
 * @called by - RefreshQueue
 * @return   function status : OK/ERROR 
 */
Status RemoveLeavedPatients(PatientQueue pq);

/**
 * according to current time, update patients' priority
 * @param  pq  patient queue
 * @call           - getCurrentTime
 * @return    function status : OK/ERROR
 */
Status RefreshPriority(PatientQueue pq);

/**
 * update patient queue information every interval times
 * @param pq   patient queue
 * @call  - ChangeBusyState
 *            - RemoveLeavedPatient
 *            - RefreshPriority
 *            - HeapSort
 * @return   function status : OK/ERROR
 */
Status RefreshQueue(PatientQueue pq);


/********** End of Function for simulation hospital**********/



/********** Function for log(Test) and print(UI)**********/

 /**   
 * log runtime information of this simulation program
 * @param  lt    log type : according to it,log correct information
 * @param  fp  file pointer : log into this file 
 * @param  tm show current time 
 * @param  pq patient queue:get enough information        
 * @call                               - showTime
 * @called by                     - PriorityQueueInsert
 *                                         - PriorityQueueDeletMax
 * @return   function status:OK/ERROR 
 */
Status Log(LogType lt, FILE * fp, Time tm, PatientQueue pq);

 /**   
 * print runtime information of this simulation program on screen 
 * @param  lt    log type : according to it,print correct information
 * @param  tm current time 
 * @param  pq patient queue:get enough information        
 * @call                              - showTime
 * @called by                    - PriorityQueueInsert
 *                                        - PriorityQueueDeletMax
 * @return   function status:OK/ERROR 
 */
Status Print(LogType lt, Time tm, PatientQueue pq);

/********** End of Function for log(Test) and print(UI)**********/




#endif
