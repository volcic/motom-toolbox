/*
    This is is a helper program for the optotrak alignment with with multiple cameras, and for dynamic datasets. The problem is that the AlignParametersStruct typedef is incorrectly read into Matlab.
    So, I made this file, which accepts the structure fields as command-line arguments. Also I hard-coded verbosity.
    Matlab declaration is:
    [fail, tolerance] = optotrak_align_system(old_camera_file_name, path_to_recording, path_to_rigid_body, new_camera_file_name, logfile_name)
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
void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int fail = -1; //this will be the return value of the function we are using
    float tolerance = 0;
    //optotrak's built-in error string:
    char error_string[MAX_ERROR_STRING_LENGTH + 1];
    //we need to sanity-check the input arguments.
    if(nrhs != 5)
    {
        mexErrMsgIdAndTxt("optotrakToolbox:optotrak_register_system_dynamic:nrhs","This function need exactly five arguments.");
    }
    nlhs = 2; //number of left-hand side arguments

    //sanity check: All arguments must be strings.
    if( (!mxIsChar(prhs[0])) || (!mxIsChar(prhs[1])) || (!mxIsChar(prhs[2])) || (!mxIsChar(prhs[3])) || (!mxIsChar(prhs[4])) )
    {
        mexErrMsgIdAndTxt("optotrakToolbox:optotrak_register_system_dynamic:nrhs", "Make sure that all input arguments are strings!");
    }
    //...and all strings must have something in them.
    if( (mxGetNumberOfElements(prhs[0]) < 2) || (mxGetNumberOfElements(prhs[1]) < 2) || (mxGetNumberOfElements(prhs[2]) < 2) || (mxGetNumberOfElements(prhs[3]) < 2) || (mxGetNumberOfElements(prhs[4]) < 2) )
    {
        mexErrMsgIdAndTxt("optotrakToolbox:optotrak_register_system_dynamic:nrhs", "None of the input arguments can be strings!");
    }
    //Also, they must not be too long!
    if( (mxGetNumberOfElements(prhs[0]) > 255) || (mxGetNumberOfElements(prhs[1]) >= 255) || (mxGetNumberOfElements(prhs[2]) >= 255) || (mxGetNumberOfElements(prhs[3]) >= 255) || (mxGetNumberOfElements(prhs[4]) >= 255) )
    {
        mexErrMsgIdAndTxt("optotrakToolbox:optotrak_register_system_dynamic:nrhs", "The Optotrak API doesn't like file names and paths to be longer than 255 characters.");
    }

    //fetch input variables, and shove them to a string. Ton of local variables.
    char *old_camera_file_name = mxArrayToString(prhs[0]);
    char *path_to_recording = mxArrayToString(prhs[1]);
    char *path_to_rigid_body = mxArrayToString(prhs[2]);
    char *new_camera_file_name = mxArrayToString(prhs[3]);
    char *logfile_name = mxArrayToString(prhs[4]);

    //Declare the structure for the function. But we only want this to exist here.
    RegisterParms registration_structure;
    //debug.
    //mexPrintf("Alignment structure created.\n");
    //mexEvalString("drawnow;");

    //now fill the structure in. But since the string were copied using pointers, I have to copy them using strcpy.
    strcpy(registration_structure.szRawDataFile, path_to_recording);
    strcpy(registration_structure.szRigidBodyFile, path_to_rigid_body);
    strcpy(registration_structure.szInputCamFile, old_camera_file_name);
    strcpy(registration_structure.szOutputCamFile, new_camera_file_name);
    strcpy(registration_structure.szLogFileName, logfile_name);

    registration_structure.fXfrmMaxError = (float) 1; //This is in millimetres.
    registration_structure.fXfrm3dRmsError = (float) 1; //This is also in millimetres.
    //Spreads tolerance is zero
    registration_structure.fSpread1 = (float) 0;
    registration_structure.fSpread2 = (float) 0;
    registration_structure.fSpread3 = (float) 0;
    // I guess this is a bit too liberal, but, meh.
    registration_structure.nMinNumberOfXfrms = 3; //We need at least 3 good transforms.

    registration_structure.nLogFileLevel = 2; // This is the most talkative
    registration_structure.bVerbose = 1; // Yes please.
    registration_structure.bCheckCalibration = 0; // Create a new camera file.
    //Now, we can execute the function.
    
    //This is for debug. Normally you won't need to print this.
    mexPrintf("Registration structure fields are:\n\tszRawDataFile: %s\n\tszRigidBodyFile: %s\n\tszInputCamFile: %s\n\tszOutputCamFile: %s\n\tszLogFileName: %s\nNow calling nOptotrakRegisterSystem()\n", registration_structure.szRawDataFile, registration_structure.szRigidBodyFile, registration_structure.szInputCamFile, registration_structure.szOutputCamFile, registration_structure.szLogFileName);
    mexEvalString("drawnow;"); //This outputs the mexPrintf immediately.
    fail = nOptotrakRegisterSystem(registration_structure, &tolerance);


    plhs[0] = mxCreateDoubleScalar(fail); //define return value type, and toss it to return.
    plhs[1] = mxCreateDoubleScalar(tolerance); //this tells me how good the new alignment is
}