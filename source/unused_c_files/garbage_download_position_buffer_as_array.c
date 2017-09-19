/*
 * This file initialises the data buffer in the memory, and downloads the position3d data
 * from the Opotrak system.
 * Then, the Position3D structure is being converted to the array, and the missing points
 * are being substituted with a NaN.
 *
 * Matlab declaration is:
 * [fail, position3d_array(number_of_frames, number_of_markers*3)] = download_position_buffer_as_array(number_of_frames, number_of_markers);
 *
 * Compile this as:
 * mex <this_file.c> <path_to_oapi(64).lib>
 * Keep this source file in the same directory as the header files.
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
    unsigned int number_of_markers = 0; //input argument: how many markers' data are in the buffer?
    float *buffer = 0; //pointer to the data buffer.
    double *output_array_pointer = 0; //this will be a pointer to the return array.
    double *row = 0; //row index pointer
    double *column = 0; //column index pointer
    long buffer_length = 0; //tells how many floats the buffer needs to be allocated.
    unsigned int spool_status = 0; //if spooling had failed, this variable will indicate.
    double nan_value = mxGetNaN(); //this will be used for invisible markers.
    unsigned int marker_offset = 0; //This will be used to adjust a single pointer across a 2D array.
    unsigned int i = 0; //loop variable
    unsigned int j = 0; //loop variable
    unsigned int k = 0; //coordinate index variable, for making the X-Y-Z triplets.

    //optotrak's built-in error string:
    char error_string[MAX_ERROR_STRING_LENGTH + 1];

    //Position3D data, as structure:
    static Position3d converted_frame[512]; //max number of markers.
    //Same, but converted to triplets:
    double converted_positions[512*3]; // this is also initialised to the maximum number of markers.

    /*
     * The buffer is raw data, we need to collect this, and then convert manually.
     * BUT, we don't know how the system is configured at the time of writing this code.
     * Here is how I calculated the worst case scenario:
     * 1., We can have a maximum of 512 markers.
     * 2., The maximum number of frames are available with 1 marker:
     *      -There are 7340031 bytes available in the ring buffer (OptotrakGetNodeInfo(0, struct))
     *        This limits how much data can actually be stored in the ring buffer, doesn't concern us
     *      -As we buffer centroid data, it's represented as one float number, which is 4 bytes. PER sensor.
     *        (float) can change with architecture, let the software worry about this.
     *      -We can have a maximum of 8*3 sensors (and I do feel sorry for you if you have to use them all)
     *        This is 24 sensors, but it can't allocate enough memory for it. So, 6 sensors it is.
     *      -We can have up to 512 markers.
     *      -The max collection time is 99999 seconds
     *      -The max sampling rate is 3600 (4600/1.3)
     * This type of initialisation can't happen at the same time, but better allocate more memory than not.
     * ...and I just allocate a piece of memory for this, and let it throw all the garbage in it.
     */
    
    buffer_length = 512 * 18 * 99999 * 3600;
    buffer = (float *)malloc(buffer_length);


    if(NULL == buffer)
    {
        //with current computers, we should never get here.
        mexErrMsgIdAndTxt("optotrakToolbox:download_position_buffer_as_array:memory", "Couldn't allocate enough memory for the buffer on the computer. Are you running this on a toaster?");
    }

    //handle input arguments.
    if(nrhs != 2)
    {
        mexErrMsgIdAndTxt("optotrakToolbox:download_position_buffer_as_array:nrhs", "This function must have only two input argument.");
    }

    if( mxGetNumberOfElements(prhs[0]) != 1 || mxGetNumberOfElements(prhs[1]) != 1)
    {
        mexErrMsgIdAndTxt("optotrakToolbox:download_position_buffer_as_array:nrhs", "Input arguments must be a scalar, and has to be a round number.");
    }
    number_of_frames = mxGetScalar(prhs[0]);
    number_of_markers = mxGetScalar(prhs[1]);
    if(number_of_markers > 512 || number_of_markers < 0)
    {
        mexErrMsgIdAndTxt("optotrakToolbox:download_position_buffer_as_array:nrhs", "The system doesn't support more than 512 markers. You need to have at least one.");
    }
    if(number_of_frames < 0 || number_of_frames > 7340031)
    {

        mexErrMsgIdAndTxt("optotrakToolbox:download_position_buffer_as_array:nrhs", "Keep the number of samples as a sensible value (0....99999*<framerate>)");
    }

    nlhs = 2;


    //Initialise memory.
    if(DataBufferInitializeMem(OPTOTRAK, buffer))
    {
        //if it went wrong, tell us why.
        if(OptotrakGetErrorString( error_string, MAX_ERROR_STRING_LENGTH + 1 ) == 0)
        {
            mexPrintf("%s\n", error_string);
            mexErrMsgIdAndTxt("optotrakToolbox:download_position_buffer_as_array:DataBufferInitializeMem", "Memory allocation failed.");
        }
        else
        {
            mexErrMsgIdAndTxt("optotrakToolbox:download_position_buffer_as_array:OptotrakGetErrorString", "Something went so wrong, even the error message printer function failed.");
        }
    }

    //Spool data: shove raw data from the Optotrak's ring buffer to the memory, as the new data comes in.
    if(DataBufferSpoolData(&spool_status))
    {
        if(OptotrakGetErrorString( error_string, MAX_ERROR_STRING_LENGTH + 1 ) == 0)
        {
            mexPrintf("Data spool status is: %d, error message: %s\n", spool_status, error_string);
            mexErrMsgIdAndTxt("optotrakToolbox:download_position_buffer_as_array:DataBufferSpoolData", "Data spooling failed.");
        }
        else
        {
            mexErrMsgIdAndTxt("optotrakToolbox:download_position_buffer_as_array:OptotrakGetErrorString", "Something went so wrong, even the error message printer function failed.");
        }
    }

    /*
    * IMPORTANT:
    * In Matlab's mex interface, a 2D matrix is allocated by COLUMNS, and not rows!
    */
    //allocate the output matrix Matlab will receive:
    plhs[1] = mxCreateDoubleMatrix((mwSize)number_of_frames, (mwSize)(number_of_markers * 3), mxREAL);
    // The second output argument is now a matrix, and I can meddle with it.
    output_array_pointer = mxGetPr(plhs[1]); //I only have a single pointer to this, to can't touch rows and columns separately.



    
    //if we got here, we have the buffer's contents in the memory. Now we need to go frame by frame.
    for(i=0; i<number_of_frames; i++)
    {
        mexPrintf("Frame %d: ", i+1);
        //fist of all, adjust the pointer to the appropriate frame.
        buffer = buffer + (i * sizeof(float) * number_of_markers);
        if(OptotrakConvertRawTo3D(&number_of_markers, buffer, &converted_frame))
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

        //now that we have the converted frame, we need to toss the data into the array.
        k = 0; //make sure we reset the variable
        for(j=0; j<number_of_markers; j++)
        {
            //copy the coordinates, and cast them to the correct format
            converted_positions[k] = (double) converted_frame[j].x;
            converted_positions[k+1] = (double) converted_frame[j].y;
            converted_positions[k+2] = (double) converted_frame[j].z;
            //print out the coordinates
            mexPrintf("%lf %lf %lf ", converted_positions[k], converted_positions[k+1], converted_positions[k+2]);
            k = k + 3; //increase the pointer by one triplet
        }
        mexPrintf(" \n");
/*
        
        //I am also replacing BAD_FLOAT to NaN, so the lives of Matlab users will be a little bit easier.
        //also, I am manually adjusting the pointer in the output array, because I couldn't find a proper way to address rows and columns
        for(j=0; (j < number_of_markers * 3); j++)
        {
            //note that I am recycling the variable j.
            if(converted_positions[j] == BAD_FLOAT)
            {
                //write NaN to the output array when the marker is invisible.
                *output_array_pointer = nan_value;
            }
            else
            {
                //write the floating-point value
                *output_array_pointer = converted_positions[j];
            }
            output_array_pointer++; // manually adjust the pointer to the next entry in the memory.
        }
    */
    }

    //If we got this far,
    plhs[0] = mxCreateDoubleScalar(0); //return the fail variable as not fail.


}