/*************************************************************************
    > File Name: Test.c
    > Author: Yilong Liu
    > Mail: sabertazimi@gmail.com
    > Website: github.com/sabertazimi/DataStructureLab/Design
    > Created Time: 2016年01月29日 星期五 09时59分09秒
    > This test is for PriorityQueue Basic Operate
 ************************************************************************/

#include "../../Lib/PriorityQueue.h"
#include <assert.h>

//open assertion testing
#undef NDEBUG

int main(void){
        /* testing variable */
        FILE *fp; //atarget to log file
        Patient patient; // tmp patient: for Insert Function and establishing testing data
        Patient *pPatient = (Patient *) malloc(sizeof(Patient)); // tmp patient pointer: for Delete Function
        // testing main body
        PatientQueue pq;
        pq.queue = NULL;
        /* testing variable */

        //open log file
        if ((fp = fopen("UnitTest.log", "at+")) == NULL) exit(INFEASIBLE);

        /* undefined test */
        assert(ClearPriorityQue(&pq) == ERROR);
        assert(PriorityQueSize(pq) == ERROR);
        assert(PriorityQueInsert(&pq, patient) == ERROR);
        assert(PriorityQueDeletMax(&pq, pPatient) == ERROR);
        assert(PriorityQueEmpty(pq) == ERROR);
        assert(PriorityQueFull(pq) == ERROR);
        assert(DestroyPriorityQue(&pq) == ERROR);
        /* undefined test */

        /* empty test */
        //initialize patient queue
        assert(InitPriorityQue(&pq) == TRUE);
        assert(ClearPriorityQue(&pq) == TRUE);
        assert(PriorityQueSize(pq) == 0);
        assert(PriorityQueDeletMax(&pq, pPatient) == ERROR);
        assert(PriorityQueEmpty(pq) == TRUE);
        assert(PriorityQueFull(pq) == FALSE);
        assert(DestroyPriorityQue(&pq) == TRUE);
        /* empty test */

        /* unit test */
        //testing for initialize function
        assert(InitPriorityQue(&pq) == TRUE);
        //testing for empty && full function
        assert(PriorityQueEmpty(pq) == TRUE);
        assert(PriorityQueFull(pq) == FALSE);

        // generate testing data
        // testing length : patients' queue initial length * 2
        for (size_t i = 0; i <= INIT_PATIENTS * 2; i++) {
            patient = NewPatient();
            //testing for full function
            if (i >= INIT_PATIENTS && i % 50 == 0) {
                //when i equals 100,150,200, it means that queue is full
                assert(PriorityQueFull(pq) == TRUE);
            } else {
                assert(PriorityQueFull(pq) == FALSE);
            }
            //testing for insert function
            assert(PriorityQueInsert(&pq, patient) == TRUE);
            //testing for empty function
            assert(PriorityQueEmpty(pq) == FALSE);
            //testing for size function
            assert(PriorityQueSize(pq) == (signed int)(i + 1));
            //log information into file
            assert(Log(ARRIVED, fp, pq, patient) == OK);
            assert(Log(QUEUE, fp, pq, patient) == OK);
        }

        //testing for delete function
        assert(PriorityQueDeletMax(&pq, pPatient) == TRUE);

        //testing for clear function
        assert(ClearPriorityQue(&pq) == TRUE);
        //testing for destory function
        assert(DestroyPriorityQue(&pq) == TRUE);
        /* unit test */

        fclose(fp);
        return 0;
}
