/*
 * DataReceiveLatestTransforms2_as_array.c - Converts and already fetched rigid body data.
 *
 *
 * The calling syntax is:
 *
 *		[fail, frame_counter, translation, rotation, positions, flags] = DataReceiveLatestTransforms2_as_array(number_of_markers);
 *
 * This is a wrapper for DataGetLatestTransforms2()
 * hint: if there are no rigid bodies defined, this function will fail.
 * note: The position 3D only gets returned to the number of markers you specify as the input argument.
 * -frame_counter is the number of frames since initialisation
 * -translation is a 1-by-n matrix in X-Y-Z triplets holding the rigid body translation data
 * -rotation is a 1-by-n matrix in roll-pitch-yaw radians.
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
void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    unsigned int fail = -1; //fail return variable
    unsigned int frame_counter = 0;
    unsigned int number_of_rigid_bodies = 0; //this is important, because we have to initialise the structure later-on.
    unsigned int flags = 0; //flag bits. Return and check for errors, if needed. Euler.
    unsigned int number_of_markers = 0; //number of markers. This is an input argument.
    double *translation_array_pointer = 0; //I will use this variable to meddle with the output matrices.
    double *rotation_array_pointer = 0; //I will use this variable to meddle with the output matrices.
    double *position3d_array_pointer = 0; //I will use this for storing the marker coordinates.
    double nan_value = mxGetNaN(); //this will be used for the bad transforms.
    int i = 0;
    int j = 0;

    //as we don't know how many rigid bodies are in the system, I am initialising to the worst case.
    static OptotrakRigid rigid_transforms[170];

    //initialise the output strucutres
    static Position3d positions[512]; //marker coordinate data.
    static Position3d translation_structure[170];
    static transformation rotation_structure[170];
  


    //Argument sanity checks
    if(nrhs != 1)
    {
        mexErrMsgIdAndTxt("optotrakToolbox:DataGetLatestTransforms2_as_array:nrhs", "This function must only have one input argument.");
    }
    //is the input argument a number?
    if( mxGetNumberOfElements(prhs[0]) != 1)
    {
        mexErrMsgIdAndTxt("optotrakToolbox:DataGetLatestTransforms2_as_array:nrhs", "Input argument must be a scalar, and has to be a round number.");
    }
    number_of_markers = mxGetScalar(prhs[0]);
    if(number_of_markers > 512 || number_of_markers < 0)
    {
        mexErrMsgIdAndTxt("optotrakToolbox:DataGetLatestTransforms2_as_array:nrhs", "The system doesn't support more than 512 markers. You need to have at least one.");
    }

    nlhs = 6; //this is the number of output arguments


    fail = DataReceiveLatestTransforms2(&frame_counter, &number_of_rigid_bodies, &flags, &rigid_transforms, &positions);
    if(number_of_rigid_bodies == 0)
    {
        mexErrMsgIdAndTxt("optotrakToolbox:DataGetLatestTransforms2_as_array:nrhs", "There were no rigid bodies defined in the system!");
    }

    //mexPrintf("number_of_rigid_bodies: %d, flags are: %d\n", number_of_rigid_bodies, flags);
    //handle output arguments
    plhs[0] = mxCreateDoubleScalar(fail); //return the fail variable.

    plhs[1] = mxCreateDoubleScalar(frame_counter); //return the captured frame counter

    

    /*
     * Euler angles. Perhaps in a later version, I'll implement the other formats too. This is the default one.
    */
    plhs[2] = mxCreateDoubleMatrix(1, number_of_rigid_bodies * 3, mxREAL); //translation
    plhs[3] = mxCreateDoubleMatrix(1, number_of_rigid_bodies * 3, mxREAL); //rotation
    translation_array_pointer = mxGetPr(plhs[2]); // This assigns the pointer to my pointer.
    rotation_array_pointer = mxGetPr(plhs[3]); // This assigns the pointer to my pointer.
    j = 0; //reset the array pointer.
    for(i=0; i<number_of_rigid_bodies; i++)
    {
        //check if we use euler. Fail if not.
        if( rigid_transforms[i].flags & !OPTOTRAK_RETURN_EULER_FLAG)
        {
            mexErrMsgIdAndTxt("optotrakToolbox:DataGetLatestTransforms2_as_array:frame_converter_loop", "The rigid body transformation method must be euler. Use RigidBodyAddFromFile_euler(), for example.");
        }

        //mexPrintf("Rigid body flags are: %d\n", rigid_transforms[i].flags);   
        if( rigid_transforms[i].flags & OPTOTRAK_UNDETERMINED_FLAG )
        {   
            //if the transform failed, 
            translation_array_pointer[j] = nan_value;
            translation_array_pointer[j+1] = nan_value;
            translation_array_pointer[j+2] = nan_value;

            rotation_array_pointer[j] = nan_value;
            rotation_array_pointer[j+1] = nan_value;
            rotation_array_pointer[j+2] = nan_value;
            
        }
        else
        {
            //copy the coordinates, and cast them to the correct format
            translation_array_pointer[j] = (double) rigid_transforms[i].transformation.euler.translation.x;
            translation_array_pointer[j+1] = (double) rigid_transforms[i].transformation.euler.translation.y;
            translation_array_pointer[j+2] = (double) rigid_transforms[i].transformation.euler.translation.z;

            //mexPrintf("X: %f, Y: %f, Z: %f\n", rigid_transforms[i].transformation.euler.translation.x, rigid_transforms[i].transformation.euler.translation.y, rigid_transforms[i].transformation.euler.translation.z);
            
            //do the same with the rotation array.
            rotation_array_pointer[j] = (double) rigid_transforms[i].transformation.euler.rotation.roll;
            rotation_array_pointer[j+1] = (double) rigid_transforms[i].transformation.euler.rotation.pitch;
            rotation_array_pointer[j+2] = (double) rigid_transforms[i].transformation.euler.rotation.yaw;

            //mexPrintf("Roll: %f, Pitch: %f, Yaw: %f", rigid_transforms[i].transformation.euler.rotation.roll, rigid_transforms[i].transformation.euler.rotation.pitch, rigid_transforms[i].transformation.euler.rotation.yaw);
        }
        j = j + 3; //increase the pointer by one triplet
    }

    plhs[4] = mxCreateDoubleMatrix(1, number_of_markers * 3, mxREAL); //position

    position3d_array_pointer = mxGetPr(plhs[4]); // This assigns the pointer to  my pointer.

    j = 0;
    for(i=0; i<number_of_markers; i++)
    {
        //copy the coordinates, and cast them to the correct format
        position3d_array_pointer[j] = (double) positions[i].x;
        position3d_array_pointer[j+1] = (double) positions[i].y;
        position3d_array_pointer[j+2] = (double) positions[i].z;

        j = j + 3; //increase the pointer by one triplet
    }
    
    //I am also replacing BAD_FLOAT to NaN, so the lives of Matlab users will be a little bit easier.
    for(i=0; (i < number_of_markers * 3); i++)
    {
        if(position3d_array_pointer[i] == BAD_FLOAT)
        {
            position3d_array_pointer[i] = nan_value;
        }
    }


    plhs[5] = mxCreateDoubleScalar(flags); //return the flags.
}