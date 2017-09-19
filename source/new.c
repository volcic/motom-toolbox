/*
 * Read the Optotrak raw data file, and then get the position3d information out out of it.
 *
 * Matlab declaration is:
 * [fail, position3d_array] = convert_raw_file_to_position3d_array(input_file_name)
 *
 * input_file_name is a string, which contains the path to the raw data file you want to read in
 * position3d_array is a n-by-m array, where n frames were read out, for m/3 markers. The marker coordinates are stored in X-Y-Z triplets.
 
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

    //optotrak's built-in error string:
    char error_string[MAX_ERROR_STRING_LENGTH + 1];


    //these are needed for the system initialisation.
    int number_of_markers = 0; //number of markers. this will be updated by OptotrakGetStatus
    float frame_rate = 0; //frame rate this will be updated by OptotrakGetStatus
    float collection_time = 0; //how long did we record for?
    long int frames_per_initialisation = 0; //this will be calculated.

    //these are needed for the file handling.
    unsigned int file_id = 0; //this is a 'unique' ID.
    unsigned int file_mode = OPEN_READ; //we don't want to write to the raw file. Not even by accident.
    int number_of_items = 0; //how many elements are in the file
    int number_of_subitems = 0; //how many sub-items are in the file
    long int number_of_frames = 0; //tells you how many frames are in the recording.
    float frame_frequency = 0; //this is stored in the config file, and you should already know.
    char comments = 0; //comment field.
    void *file_pointer = 0; //NDI asks you not to use it.

    //these are needed for the loops I am using
    unsigned long int i = 0;
    unsigned long int j = 0;
    unsigned long int k = 0;

    //These are needed for the conversion.
    void * one_frame_data; //this will point to the allocated memory holding one frame of raw data.
    unsigned int number_of_elements = 0; //this will be a detected marker counter.
    static Position3d converted_positions[512]; //512 is the maximum number of markers we have.

    //these are needed for the export.
    double nan_value = mxGetNaN(); //this will be used for invisible markers.
    double *position_array_pointer = 0; //I will have to manually adjust this to fill the output array with data.
    unsigned long int frame_offset = 0; //I store the data in rows, but the consecutive memory blocks are columns.


    //handle input arguments.
    if(nrhs != 1)
    {
        mexErrMsgIdAndTxt("optotrakToolbox:convert_raw_file_to_position3d_array:nrhs", "This function must have only one input argument.");
    }
    //both input arguments must be a string.
    if( !mxIsChar(prhs[0]))
    {
        mexErrMsgIdAndTxt("optotrakToolbox:convert_raw_file_to_position3d_array:nrhs", "Make sure that the input argument is a string!");
    }
    //...and both strings must have something in it.
    if( mxGetNumberOfElements(prhs[0]) < 2)
    {
        mexErrMsgIdAndTxt("optotrakToolbox:convert_raw_file_to_position3d_array:nrhs", "The input file name can't be empty!");
    }

    nlhs = 2; //number of output arguments

    //We need to check if the system is initialised. And while we are there, get the number of markers out too!
    if(OptotrakGetStatus(NULL, NULL, NULL, &number_of_markers, &frame_rate, NULL, NULL,  NULL, NULL, NULL, NULL, &collection_time, NULL, NULL))
    {
        //if it went wrong, tell us why.
        if(OptotrakGetErrorString( error_string, MAX_ERROR_STRING_LENGTH + 1 ) == 0)
        {
            mexPrintf("%s\n", error_string);
            mexErrMsgIdAndTxt("optotrakToolbox:convert_raw_file_to_position3d_array:OptotrakGetStatus", "Couldn't read system status. The system must be initialised properly before it can convert data.");
        }
        else
        {
            mexErrMsgIdAndTxt("optotrakToolbox:convert_raw_file_to_position3d_array:OptotrakGetErrorString", "Something went so wrong, even the error message printer function failed.");
        }
    }
    //if you load the collection settings without initialising the system, this will be 0.
    frames_per_initialisation = frame_rate * collection_time;
    if(!frames_per_initialisation)
    {
        //if the system reports 0 frames to be collected, then kill this script.
        mexErrMsgIdAndTxt("optotrakToolbox:convert_raw_file_to_position3d_array:OptotrakGetStatus", "Couldn't read system status. The system must be initialised properly before it can convert data.");
    }


    mexPrintf("The number of markers: %d, frame rate: %f, collection_time: %f. Results %d frames.\n", number_of_markers, frame_rate, collection_time, frames_per_initialisation); //debug

    //now that we know the status, we can allocate our output array.

        
    plhs[1] = mxCreateDoubleMatrix(frames_per_initialisation, number_of_markers * 3, mxREAL); //this is a pointer for the array I created here.
    position_array_pointer = mxGetPr(plhs[1]); // This assigns the pointer to  my pointer.


    //Now we can open the raw file.
    if(FileOpen(mxArrayToString(prhs[0]), file_id, file_mode, &number_of_items, &number_of_subitems, &number_of_frames, &frame_frequency, &comments, &file_pointer))
    {
        //if it went wrong, tell us why.
        if(OptotrakGetErrorString( error_string, MAX_ERROR_STRING_LENGTH + 1 ) == 0)
        {
            mexPrintf("%s\n", error_string);
            mexErrMsgIdAndTxt("optotrakToolbox:convert_raw_file_to_position3d_array:FileOpen", "Couldn't load raw data file.");
        }
        else
        {
            mexErrMsgIdAndTxt("optotrakToolbox:convert_raw_file_to_position3d_array:OptotrakGetErrorString", "Something went so wrong, even the error message printer function failed.");
        }
    }

    
    //Now that we know what the file contains, we can do the conversion.


    //mexPrintf("Found %d frames, and %d elements, with %d sub-items.\n", number_of_frames, number_of_items, number_of_subitems); //for debugging.
    for(i=0; i<number_of_frames; i++)
    {
        //I must allocate memory programmatically, here:
        one_frame_data = (float *) malloc((number_of_items * number_of_subitems)*10);
        //Take each frame
        //mexPrintf("Reading frame %d, ", i); //debug.
        if(FileRead(file_id, i, 1, one_frame_data)) //read 1 data frame to the allocated memory.
        {
            //if it went wrong, tell us why.
            if(OptotrakGetErrorString( error_string, MAX_ERROR_STRING_LENGTH + 1 ) == 0)
            {
                mexPrintf("%s\n", error_string);
                mexErrMsgIdAndTxt("optotrakToolbox:convert_raw_file_to_position3d_array:FileRead", "The file was opened, but couldn't be read.");
            }
            else
            {
                mexErrMsgIdAndTxt("optotrakToolbox:convert_raw_file_to_position3d_array:OptotrakGetErrorString", "Something went so wrong, even the error message printer function failed.");
            }
        }
        //...and do the conversion for each frame!
        if(OptotrakConvertRawTo3D(&number_of_elements, one_frame_data, &converted_positions)) //need to watch for pointers here.
        {
            //if it went wrong, tell us why.
            if(OptotrakGetErrorString( error_string, MAX_ERROR_STRING_LENGTH + 1 ) == 0)
            {
                mexPrintf("%s\n", error_string);
                mexErrMsgIdAndTxt("optotrakToolbox:convert_raw_file_to_position3d_array:OptotrakConvertRawTo3D", "Couldn't convert raw data to positions.");
            }
            else
            {
                mexErrMsgIdAndTxt("optotrakToolbox:convert_raw_file_to_position3d_array:OptotrakGetErrorString", "Something went so wrong, even the error message printer function failed.");
            }
        }

        //we should never get here, but just in case.
        if(number_of_elements != number_of_markers)
        {
            mexErrMsgIdAndTxt("optotrakToolbox:convert_raw_file_to_position3d_array:frame_converter_loop", "The number of elements in a raw frame do not match with the number of markers initialised in the system.");
        }

        //mexPrintf("number of markers: %d\n", number_of_elements); //debug.
        
        //Now I need to convert the position3d structure to a 2D array.
        k = 0; //this will be the internal array pointer
        /* 
         * Matlab organised the output array as such that the consecutive memory addresses correspond in columns.
         * I organised the data in rows.
         * This means, that my pointer addressing is a little haywire.
         */
    


        for(j=0; j < number_of_elements; j++)
        {
            k = (number_of_frames*3)*j + i; //increase the pointer by one triplet so the data will be in rows

            //copy the coordinates, and cast them to the correct format. Or if it's invisible, toss it a NaN!
            if( converted_positions[j].x == BAD_FLOAT)
            {
                position_array_pointer[k] = nan_value;
            }
            else
            {
                position_array_pointer[k] = (double) converted_positions[j].x;
            }
            
             if( converted_positions[j].y == BAD_FLOAT)
            {
                position_array_pointer[k + number_of_frames] = nan_value;
            }
            else
            {
                position_array_pointer[k + number_of_frames] = (double) converted_positions[j].y;
            }

            if( converted_positions[j].z == BAD_FLOAT)
            {
                position_array_pointer[k + (number_of_frames*2)] = nan_value;
            }
            else
            {
                position_array_pointer[k + (number_of_frames*2)] = (double) converted_positions[j].z;
            }

        }
        //I now must free the memory I just allocated
        free(one_frame_data);   

    }

    FileClose(file_id); //Close the file.

    fail = 0;
    plhs[0] = mxCreateDoubleScalar(fail); //define return value type, and toss it to return.

}