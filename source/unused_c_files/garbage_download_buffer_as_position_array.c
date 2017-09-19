/*
 * This function downloads centroid data from the allocated memory location.
 * Then, it converts it to position3d data, and tosses it back to Matlab as a 2D array,
 * with NaNs inserted for the invisible markers.
 *
 * Matlab declaration is:
 * [fail, position3d_as_array] = download_buffer_as_position_array(buffer_address, number_of_frames);
 * If you want to record for a long time, I suggest you use DataBufferInitializeFile()
 *
 * Compile this as:
 * mex <this_file.c> <path_to_oapi(64).lib>
 * Keep this source file in the same directory as the header files
 */

//Standard C-library
#include <string.h>

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
    int fail = -1; //this is the output function.
    unsigned int number_of_frames = 0; //input argument: how many frames are in the buffer?

    //We need to know where in the memory the buffer is allocated to.
    unsigned long buffer_address = 0;
    double *buffer = 0;

    //optotrak's built-in error string:
    char error_string[MAX_ERROR_STRING_LENGTH + 1];
    //as we don't know yet how many markers we have, initialise memory for the worst case.
    static Position3d converted_frame[512]; //this is a structure in wich OptotrakConvertRawTo3D() writes to
    unsigned int number_of_markers = 0; //OptotrakConvertRawTo3D will fill this up for us.
    double marker_coords_in_triplets[512*3]; //this is an array which we meddle with internally.
    double nan_value = mxGetNaN(); //this will be used for invisible markers.

    //as we don't know yet how many frames and markers we have, this pointer must be stepped manually.
    double *output_array_pointer = 0;

    unsigned int i = 0; //loop variable
    unsigned int j = 0; //loop variable
    unsigned int k = 0; //coordinate index variable, for making the X-Y-Z triplets.


    //handle input arguments.
    if(nrhs != 2)
    {
        mexErrMsgIdAndTxt("optotrakToolbox:download_position_buffer_as_array:nrhs", "This function must have two input arguments.");
    }

    if( mxGetNumberOfElements(prhs[0]) != 1 || mxGetNumberOfElements(prhs[1]) != 1)
    {
        mexErrMsgIdAndTxt("optotrakToolbox:download_position_buffer_as_array:nrhs", "Input arguments must be a scalar, and has to be a round number.");
    }
    //now we can collect the input arguments
    buffer_address = mxGetScalar(prhs[0]);
    //mexPrintf("Buffer address is %d.\n", buffer_address);
    buffer = buffer_address;

    number_of_frames = mxGetScalar(prhs[1]);
    

    if(number_of_markers > 512 || number_of_markers < 0)
    {
        mexErrMsgIdAndTxt("optotrakToolbox:download_position_buffer_as_array:nrhs", "The system doesn't support more than 512 markers. You need to have at least one.");
    }
    if(number_of_frames < 0 || number_of_frames > 25920000)
    {

        mexErrMsgIdAndTxt("optotrakToolbox:download_position_buffer_as_array:nrhs", "Keep the number of samples as a sensible value (0....7200*<framerate>)");
    }

    nlhs = 2; //number of output arguments.



    /*
    * IMPORTANT:
    * In Matlab's mex interface, a 2D matrix is allocated by COLUMNS, and not rows!
    */
    //allocate the output matrix Matlab will receive:
    plhs[1] = mxCreateDoubleMatrix((mwSize)number_of_frames, (mwSize)(number_of_markers * 3), mxREAL);
    // The second output argument is now a matrix, and I can meddle with it.
    output_array_pointer = mxGetPr(plhs[1]); //I only have a single pointer to this, and I can't touch rows and columns separately.

    //Process a single frame.
    if(OptotrakConvertRawTo3D(&number_of_markers, &buffer, &converted_frame))
    {
        //if it went wrong, tell us why.
        if(OptotrakGetErrorString( error_string, MAX_ERROR_STRING_LENGTH + 1 ) == 0)
        {
            mexPrintf("%s\n", error_string);
            mexErrMsgIdAndTxt("optotrakToolbox:download_position_buffer_as_array:OptotrakConvertRawTo3D", "Couldn't convert the raw data to 3D positions.");
        }
        else
        {
            mexErrMsgIdAndTxt("optotrakToolbox:download_position_buffer_as_array:OptotrakGetErrorString", "Something went so wrong, even the error message printer function failed.");
        } 
    }

    /*
     * Now we have a frame, dispense it to the array. We have to be peculiar with the pointer addressing,
     * because the consecutive memory addresses are in columns, and not rows.
     */
    
    k = 0; //make sure we reset the array triplet counter variable
    for(j=0;j<number_of_markers; j++)
    {
        //mexPrintf("Number of markers: %d\n", number_of_markers);
        //move data from the structure to the array.
        //copy the coordinates, and cast them to the correct format
        //mexPrintf("Marker %d:\n", j);
        marker_coords_in_triplets[k] = (double) converted_frame[j].x;
        marker_coords_in_triplets[k+1] = (double) converted_frame[j].y;
        marker_coords_in_triplets[k+2] = (double) converted_frame[j].z;
        //print out the coordinates
        mexPrintf("%lf %lf %lf ", marker_coords_in_triplets[k], marker_coords_in_triplets[k+1], marker_coords_in_triplets[k+2]);
        k = k + 3; //increase the pointer by one triplet
    }

    mexPrintf("\n");
}