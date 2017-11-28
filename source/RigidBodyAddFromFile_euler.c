/*
 * RigidBodyAddFromFile_euler.c - This function reads a rigid body file, and adds it to the system.
 *
 *
 * The calling syntax is:
 *
 *		[fail] = RigidBodyAddFromFile_euler(rigid_body_id, start_marker, rigid_body_file);
 *
 * This is a wrapper for RigidBodyAddFromFile(), and it locks the user to use Euler (pitch, roll, yaw) angles with translation
 * Input arguments are:
 * -> rigid_body_id is the ID you want to assign
 * -> start_marker is the first marker of the rigid body. It may be different from 1.
 * -> no_of_markers is the number of markers on the rigid body. At least 3 are needed. The max is 512.
 * -> rigid_body_file is the file, which is by default in C:\ndigital/rigid/*.rig. Do not use the extension.
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
void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    unsigned int fail = -1; //fail return variable
    int rigid_body_id = 0;
    int start_marker = 0;
    char *rigid_body_file_name_pointer; //this will be the pointer to the file name


    //input argument sanity checks: Are we OK for numbers?
    if(nrhs != 3)
    {
        mexErrMsgIdAndTxt("optotrakToolbox:RigidBodyAddFromFile_euler:nrhs", "This function must have 3 input arguments.");
    }
    // Are the number arguments number arguments?
    if( !(mxIsDouble(prhs[0])) || mxGetNumberOfElements(prhs[0]) != 1 || !(mxIsDouble(prhs[1])) || mxGetNumberOfElements(prhs[1]) != 1 )
    {
        mexErrMsgIdAndTxt("optotrakToolbox:RigidBodyAddFromFile_euler:nrhs", "The input arguments must be double and (the defult Matlab format when you declare a variable)");
    }
    

    //Assign the input arguments to the internal variables
    rigid_body_id = mxGetScalar(prhs[0]);
    start_marker = mxGetScalar(prhs[1]);
    //is the first marker larger than zero?
    if(start_marker <= 0)
    {
        mexErrMsgIdAndTxt("optotrakToolbox:RigidBodyAddFromFile_euler:nrhs", "The first marker in the optotrak system is 1. Can't be less than that!");
    }
    //string argument!
    rigid_body_file_name_pointer = mxArrayToString(prhs[2]);
    //is the string empty?
    if(!strlen(rigid_body_file_name_pointer))
    {
         mexErrMsgIdAndTxt("optotrakToolbox:RigidBodyAddFromFile_euler:nrhs", "The fourth argument must be a file name (WITHOUT extension!)");
    }


    //output arguments:
    nlhs = 1;

    fail = RigidBodyAddFromFile(rigid_body_id, start_marker, rigid_body_file_name_pointer, OPTOTRAK_RETURN_EULER_FLAG); //set the euler processing stuff.


    //handle output arguments
    plhs[0] = mxCreateDoubleScalar(fail); //return the fail variable.



}