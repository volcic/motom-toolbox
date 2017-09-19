/*
 * RequestLatest3D_data.c This function requests 3D optotrak data
 * This method doesn't work properly, because it leads to MessageSystem errors.
 * 
 * 
 * Compile this as:
 * mex <this_file.c> <path_to_oapi(64).lib>
 * Keep this source file in the same directory as the header files.
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
    int fail = -1;

    //we need to sanity-check the input argument.
    if(nrhs > 0)
    {
        mexErrMsgIdAndTxt("optotrakToolbox:DataGetLatest3D_as_array:nrhs", "This function must not have an input argument.");
    }
    nlhs = 1; //number of left-hand side arguments, which I set


    fail = RequestLatest3D();
    if(fail)
    {
        mexPrintf("RequestNext3D failed. Proceeding.");
    }

    fail = -1; //re-initialise the variable.


    while(fail)
    {
        fail = DataIsReady();
        //Hang here until the frame gets collected.
        /*if(fail)
        {
            mexPrintf("DataIsReady failed.");
        }*/
    }
    fail = 0;

    //return the variable.

    plhs[0] = mxCreateDoubleScalar(fail);
}