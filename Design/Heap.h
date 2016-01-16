/*************************************************************************
	> File Name: Heap.h
	> Author: CS1409 U201414800 Yilong Liu 
	> Mail: hustlyl@163.com 
              > Website: sabertazimi.github.io
	> Created Time: 2016年01月15日 星期五 18时07分54秒
 ************************************************************************/

#ifndef  _HEAP_H
#define _HEAP_H

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>    //define variable parameter function, e.g Log
#include <time.h>

//macro
#define TRUE 1
#define FALSE 0
#define OK 1
#define ERROR 0
#define INFEASIBLE -1
#define OVERFLOW -2

//maxinum of PATIENTS 
#define MAX_PATIENTS 100
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
 * @return   function status:OK/ERROR 
 */
Status InitPriorityQue(PatientQueue pq);

/**
 * Destory patient queue
 * @param  pq  patient queue
 * @return   function status:OK/ERROR 
 */
Status DestroyPriorityQue(PatientQueue pq);

/**
 * Clear up patient queue
 * @param  pq  patient queue
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
 * @return   function status:OK/ERROR 
 */
Status PriorityQueInsert(PatientQueue pq);

/**
 * delete patient  who has highest priority
 * @param  pq  patient queue
 * @return  deleted patient 
 */
Patient PriorityQueDeletMax(PatientQueue pq);

/**
 * check patient queue whether empty or not
 * @param  pq  patient queue
 * @return   function status:TRUE/FALSE
 */
Status PriorityQueEmpty(PatientQueue pq);

/**
 * check patient queue whether full or not
 * @param  pq  patient queue
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
* @return   function status:OK/ERROR 
*/
Status HeapSort(PatientQueue pq); 

/********** End of Function for heap sort **********/



/********** Function for simulation hospital**********/

 /**
 * according to sicktype,simulate and evaluate treatingLength
 * @param  st  sick types
 * @return        treating length
 */
Time getTreatingLength(SickType st);

/**
 * get current system time
 * @return  current system time(float)
 */
Time getCurrentTime();

/**
 * log current system time to target file or stand outputstream
 * @param  fp file pointer to target file
 * @param  tm curren system time
 * @return   function status:OK/ERROR 
 */
Status showCurrentTime(FILE * fp, Time tm);

/********** End of Function for simulation hospital**********/



/********** Function for log(Test) and print(UI)**********/

 /**   
 * log runtime information of this simulation program
 * @param  lt    		 log type : according to it,log correct information
 * @param  fp   		 file pointer : log into this file 
 * @param  systemTime show current time 
 * @param  pq                  patient queue:get enough information        
 * @return   function status:OK/ERROR 
 */
Status Log(LogType lt, FILE * fp, Time systemTime, PatientQueue pq);

 /**   
 * print runtime information of this simulation program on screen 
 * @param  lt    		 log type : according to it,print correct information
 * @param  systemTime show current time 
 * @param  pq                  patient queue:get enough information        
 * @return   function status:OK/ERROR 
 */
Status Print(LogType lt, Time systemTime, PatientQueue pq);

/********** End of Function for log(Test) and print(UI)**********/




#endif
