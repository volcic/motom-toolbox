/*
    This file contains a bunch of data handling functions for Zoltan's Optotrak toolbox.
    I had to make these, becuase Matlab hates passing on nested structures and structure arrays.
    So, these functions are written as a wrapper to the loaded OAPI library,
    and the return values are in nice and convenient 2D arrays which are easier to handle in Matlab.
*/

//optotrak-specific headers
#include "ndopto.h"
#include "ndpack.h"
#include "ndtypes.h"
#include "ndhost.h"

//matlab-specific headers
#include "mex.h"
#include "matrix.h"

// matlab's gateway function.
void mexFunction(int nlhs, mxArray *plhs[],
                int nrhs, mxArray *prhs[])
{
    int fail = -1; //this will be the return value of the function we are using
    //we need to sanity-check the input arguments.
    if(nrhs > 0)
    {
        mexErrMsgIdAndTxt("optotrakToolbox:optotrak_test:nrhs","This function must not have an input argument.");
    }
    nlhs = 1; //number of left-hand side arguments

    
    fail = TransputerDetermineSystemCfg(""); //empty string.
    mexPrintf("This function didn't crash yet. Good.\n");

   
    plhs[0] = mxCreateDoubleScalar(fail); //define return value type, and toss it to return.
}