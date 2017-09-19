/*
 * DataReceiveLatest3D_as_array.c - Returns the captured Position3D data as a 2D array
 *
 * This function only works if you executed RequestLatest3D(), AND, you waited until DataIsReady() says so!
 * The calling syntax is:
 *
 *		[frame_counter, position3d_array, flags] = DataGetNext3D_as_array();
 *
 * This is a wrapper for DataReceiveLatest3D(), but it returns the Position3D data as a 2D array, as opposed to structure array.
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
    int fail = -1; //this will be the return value of the function we are using
    unsigned int i = 0; //loop variable
    unsigned int j = 0; //array pointer.
    double *output_array_pointer = 0; //this will be a pointer.
    unsigned int frame_counter = 0; //this will store the number of frames.
    unsigned int number_of_markers = 0; //this will tell us how many markers should we expect
    unsigned int flags = 0; //I will just return this without doing anything with it.
    double nan_value = mxGetNaN(); //this will be used for invisible markers.
    // At this time, we don't know how many markers we have, so initialise everything for the worst case.
    static Position3d data_structure[512];

    //we need to sanity-check the input argument.
    if(nrhs > 0)
    {
        mexErrMsgIdAndTxt("optotrakToolbox:DataReceiveLatest3D_as_array:nrhs", "This function must not have an input argument.");
    }
    nlhs = 4; //number of left-hand side arguments, which I set

    
    fail = DataReceiveLatest3D(&frame_counter, &number_of_markers, &flags, &data_structure);
    plhs[0] = mxCreateDoubleScalar(fail); //define return value type, and toss it to return.
    /*
    mexPrintf("Frame counter: %d\n", frame_counter); //debug
    mexPrintf("Number of markers: %d\n", number_of_markers); //debug
    */

    plhs[1] = mxCreateDoubleScalar(frame_counter); //toss back the frame counter too.

    //now we need to generate the output array.
    plhs[2] = mxCreateDoubleMatrix(1, number_of_markers * 3, mxREAL); //this is a pointer for the array I created here.
    output_array_pointer = mxGetPr(plhs[2]); // This assigns the pointer to  my pointer.

    for(i=0; i<number_of_markers; i++)
    {
        //copy the coordinates, and cast them to the correct format
        output_array_pointer[j] = (double) data_structure[i].x;
        output_array_pointer[j+1] = (double) data_structure[i].y;
        output_array_pointer[j+2] = (double) data_structure[i].y;

        j = j + 3; //increase the pointer by one triplet
    }

    //I am also replacing BAD_FLOAT to NaN, so the lives of Matlab users will be a little bit easier.
    for(i=0; (i < number_of_markers * 3); i++)
    {
        if(output_array_pointer[i] == BAD_FLOAT)
        {
            output_array_pointer[i] = nan_value;
        }
    }

    plhs[3] = mxCreateDoubleScalar(flags); //toss the flag bits back.
   
}