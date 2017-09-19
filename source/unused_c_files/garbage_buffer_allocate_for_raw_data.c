/*
 * This function initialises the data buffer in the memory.
 * I am allocating the buffer for raw data, so I can do all the conversions after the data has been collected.
 * Matlab declaration is:
 * [fail, buffer_pointer] = buffer_allocate_for_raw_data();
 * WARNING: I allocate about 4 GB of your memory!
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
    unsigned long buffer_length = 0; //this will be the number of floats the data buffer is being initialised to.
    float *buffer = 0; //pointer to the data buffer.
    unsigned long buffer_address = 0;

    //optotrak's built-in error string:
    char error_string[MAX_ERROR_STRING_LENGTH + 1];

    //Position3D data, as structure:
    static Position3d converted_frame[512]; //max number of markers.
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
     *      -The max collection time is 99999 seconds. I am limiting this to 7200 seconds. 2 hours of data should be enough!
     *      -The max sampling rate is 3600 (4600/1.3)
     * This type of initialisation can't happen at the same time, but better allocate more memory than not.
     * ...and I just allocate a piece of memory for this, and let it throw all the garbage in it.
     */  
    buffer_length = 512 * 24 * 7200 * 3600;
    //want to see how much data you allocated? Uncomment the following line.
    //mexPrintf("The data buffer is %d MB long", (buffer_length*4)/(1024*1024));
    buffer = (float *)malloc(buffer_length);
    buffer_address = &buffer;

    mexPrintf("Buffer address is %d\n", buffer_address);

    //handle input arguments
    if(NULL == buffer)
    {
        //with current computers, we should never get here.
        mexErrMsgIdAndTxt("optotrakToolbox:buffer_allocate_for_raw_data:memory", "Couldn't allocate enough memory for the buffer on the computer. Are you running this on a toaster?");
    }

    //handle input arguments.
    if(nrhs != 0)
    {
        mexErrMsgIdAndTxt("optotrakToolbox:buffer_allocate_for_raw_data:nrhs", "This function must not have any input arguments.");
    }

    nlhs = 2; //only 1 return value.
    //Initialise memory.
    if(DataBufferInitializeMem(OPTOTRAK, buffer))
    {
        //if it went wrong, tell us why.
        if(OptotrakGetErrorString( error_string, MAX_ERROR_STRING_LENGTH + 1 ) == 0)
        {
            mexPrintf("%s\n", error_string);
            mexErrMsgIdAndTxt("optotrakToolbox:buffer_allocate_for_raw_data:DataBufferInitializeMem", "Memory allocation failed.");
        }
        else
        {
            mexErrMsgIdAndTxt("optotrakToolbox:buffer_allocate_for_raw_data:OptotrakGetErrorString", "Something went so wrong, even the error message printer function failed.");
        }
    }
    fail = 0;


    //return the fail variable.
    plhs[0] = mxCreateDoubleScalar(fail); //return the fail variable
    plhs[1] = mxCreateDoubleScalar(buffer_address); //return the buffer pointer address. 


}
 