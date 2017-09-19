/*
 * This file is to be compiled as a .mex file, and this initialises the Optotrak system with the C API.
 * Once the initialisation was successful, it saves a config file which can be used as a template.
 *
 * This creates a config file which works with DataGet****,
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

    //local variables for the initialisation. Change this at will, but you won't really need it.
    int number_of_markers = 6;
    float frame_rate = 30; //Hz.
    float marker_frequency = frame_rate * (number_of_markers + 2.3); // marker frequency is for the worst case scencario
    int threshold = 30; //static, or dynamic.
    int minimum_gain = 160; //as per the example script.
    int are_we_streaming = 0; //Buffer the data.
    //Watch for these two. Cranking up the voltage and the duty cycle together will kill the IR LEDs.
    float marker_duty_cycle = 0.2;
    float marker_voltage = 7;
    float buffer_length = 10; //in seconds
    float pre_trigger_time = 0; //this always must be 0.
    //Generate the flags here. Since we are in C, we can use the handy mnemonical constants.
    unsigned int flags = OPTOTRAK_BUFFER_RAW_FLAG; //We convert this to get the 3D data.

    //optotrak's built-in error string:
    char error_string[MAX_ERROR_STRING_LENGTH + 1];


    //handle input arguments.
    if(nrhs > 0)
    {
        mexErrMsgIdAndTxt("optotrakToolbox:dump_config_file_for_buffered:nrhs", "This function must not have an input argument.");
    }
    nlhs = 1;

    
    //For blocking, we need to set additional processing flags.
    fail = OptotrakSetProcessingFlags(OPTO_CONVERT_ON_HOST | OPTO_RIGID_ON_HOST);
    if(fail)
    {
        mexErrMsgIdAndTxt("optotrakToolbox:dump_config_file_for_buffered:OptotrakSetProcessingFlags", "Couldn't set the processing flag.");
    }

    fail = OptotrakSetupCollection(number_of_markers, frame_rate, marker_frequency, threshold, minimum_gain, are_we_streaming, marker_duty_cycle, marker_voltage, buffer_length, pre_trigger_time,  flags);

    if(fail)
    {
        mexPrintf("ERROR:\n");
        //try tossing some error message out.
        if(OptotrakGetErrorString( error_string, MAX_ERROR_STRING_LENGTH + 1 ) == 0)
        {
            mexPrintf("%s\n", error_string);
        }
        mexErrMsgIdAndTxt("optotrakToolbox:dump_config_file_for_buffered:OptotrakSetupCollection", "Couldn't set up the Optotrak system.");
    }

    //Assuming the software haven't failed, now we can dump the config file, which can be used.
    fail = OptotrakSaveCollectionToFile("buffer_with_blocking");
    if(fail)
    {
        mexPrintf("ERROR:\n");
        //try tossing some error message out.
        if(OptotrakGetErrorString( error_string, MAX_ERROR_STRING_LENGTH + 1 ) == 0)
        {
            mexPrintf("%s\n", error_string);
        }
        mexPrintf("Couldn't write config file.\n");
        mexErrMsgIdAndTxt("optotrakToolbox:dump_config_file_for_buffered:OptotrakSaveCollectionToFile", "Couldn't write config file.");
    }


    plhs[0] = mxCreateDoubleScalar(fail);
}