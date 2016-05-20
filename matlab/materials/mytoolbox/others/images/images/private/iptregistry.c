/* Copyright 1993-1998 The MathWorks, Inc.  All Rights Reserved. */

/* $Revision: 1.3 $ */

/*
 * IPTREGISTRY.MEX
 *
 * Usage:
 *         IPTREGISTRY(A) stores A in persistent memory.
 *         A = IPTREGISTRY returns the value currently stored.
 *
 * Once called, IPTREGISTRY cannot be cleared by calling clear mex.
 *
 * Steven L. Eddins, September 1996
 *
 */

static char rcsid[] = "$Id: iptregistry.c,v 1.3 1997/11/24 15:57:04 eddins Exp $";

#include "mex.h"

static mxArray *Registry = NULL;

void unloadIPTRegistry(void)
{
    mxDestroyArray(Registry);
    Registry = NULL;
    mexUnlock();
}

void mexFunction(int nlhs, 
                 mxArray *plhs[], 
                 int nrhs, 
                 const mxArray *prhs[])
{
    if (nrhs > 1)
    {
        mexErrMsgTxt("Too many input arguments");
    }
    if (nlhs > 1)
    {
        mexErrMsgTxt("Too many output arguments");
    }

    if (Registry == NULL)
    {
        /* First time call */
        mexAtExit(unloadIPTRegistry);
        Registry = mxCreateDoubleMatrix(0, 0, mxREAL);
        mexMakeArrayPersistent(Registry);
        mexLock();
    }
    
    if (nrhs == 1)
    {
        mxDestroyArray(Registry);
        Registry = mxDuplicateArray(prhs[0]);
        mexMakeArrayPersistent(Registry);
    }
    
    plhs[0] = mxDuplicateArray(Registry);
}
