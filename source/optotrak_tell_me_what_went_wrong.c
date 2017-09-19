/*
 * This piece of code is useful when you run into some problems with the optotrak system.
 * You can also look at opto.err, it might help you with finding out what's wrong.
 *
 * There are no input arguments, and no output arguments. It simply prints to Matlab's command window.
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
    unsigned int fail = -1; //fail return variable
    //optotrak's built-in error string:
    char error_string[MAX_ERROR_STRING_LENGTH + 1];

    //handle the input
    if(nrhs > 0)
    {
        mexErrMsgIdAndTxt("optotrakToolbox:dump_config_file_for_blocking_streaming:nrhs", "This function must not have an input argument.");
    }
    nlhs = 0;

    if(OptotrakGetErrorString( error_string, MAX_ERROR_STRING_LENGTH + 1 ) == 0)
    {
        mexPrintf("The optotrak system says: %s\n", error_string);
    }
    else
    {
        mexErrMsgIdAndTxt("optotrakToolbox:dump_config_file_for_streaming_with_blocking:OptotrakSetupCollection", "Something went so wrong, even the error message printer function failed.");
    }

    //mexPrintf("There are no error messages stored in the Optotrak system.\n");


}