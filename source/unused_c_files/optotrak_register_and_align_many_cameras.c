/*
    This function is to be used with many cameras.
    It implements a ton of API functions:
        -to initialise a system, 
        -to collect raw data and then save it to disk, 
        -and then use the collected data to generate a camera file that has 
        -been aligned with the local coordinate system of the loaded rigid body.
        -...and to do this within Matlab.
    
    The declaration is the following:
    [fail, tolerance] = optotrak_register_and_align_many_cameras(collection_setup_file, path_to_rigid_body, output_camera_file)
    
    All interim files (logs, unaligned camera files, recorded raw daata) generated are hard-coded, and will be dumped in the directory wherever you want to run this from.
    Pretty much everything is sequential. Since we are running in Matlab, we shouldn't be jumping about like a chimpanzee in the code.
*/

//optotrak-specific headers
#include "ndopto.h"
#include "ndpack.h"
#include "ndtypes.h"
#include "ndhost.h"

//matlab-specific headers
#include "mex.h"
#include "matrix.h"


//This is effectively optotrak_tell_me_what_went_wrong.c, but I wanted to keep this stand-alone.
void internal_complain_to_me(void)
{
    char error_string[MAX_ERROR_STRING_LENGTH + 1]; //optotrak's built-in error string:
    //Tell us why we failed.
    if(!(OptotrakGetErrorString( error_string, MAX_ERROR_STRING_LENGTH + 1 )))
    {
        mexPrintf("The optotrak system says: %s\n", error_string);
        mexErrMsgIdAndTxt("optotrakToolbox:optotrak_register_and_align_many_cameras", "Check opto.err for details.");
    }
    else
    {
        mexErrMsgIdAndTxt("optotrakToolbox:optotrak_register_and_align_many_cameras:OptotrakSetupCollection", "Something went so wrong, even the error message printer function failed.");
    }
}



// matlab's gateway function.
void mexFunction(int nlhs, mxArray *plhs[],
                int nrhs, mxArray *prhs[])
{
    //Local variable declarations.
    int fail = -1; //this will be the return value of the function we are using
    float tolerance = 0; //This will be the output tolerance

    //The input parameters will be here. I need to muck about with the memory.
    char *collection_setup_file;
    char *path_to_rigid_body;
    char *output_camera_file;

    // I have to toss some dynamic stuff back at Matlab, from the compiled mex file.
    char eval_string[10]; 


    //This lot is needed for OptotrakGetStatus()
    int number_of_sensors = 0; //1 camera module has 3 sensors.
    int number_of_odaus = 0; //the number of ODAUs connected up to the system.
    int number_of_rigid_bodies = 0; //how many rigid bodies are loaded?
    int number_of_markers = 0; //How many markers are we using?
    float frame_rate = 0; //Also called 'frame frequency'.
    float marker_frequency = 0; //This is the frequency the markers are being flashed with, so all markers will have its time within a frame.
    int threshold = 0; //Marker brightness threshold for the sensor
    int minimum_gain = 0; //Sensor gain
    int are_we_streaming = 0; //If this is 0, then we are buffering instead.
    float marker_duty_cycle = 0; //You can dim the markers, if needed (i.e. they saturate the camera or overheat)
    float marker_voltage = 0; //This is the voltage that gets to the photodiodes
    float collection_time = 0; //Effectively, trial length.
    float pre_trigger_time = 0; //Unimplemented and is hard-coded to 0.
    int collection_flags = 0; // A ton of flag bits. Namely up to 16 of them.

    //Data buffering-related variables
    unsigned int there_is_data = 0;
    unsigned int spooling_completed = 0;
    unsigned int spool_status = 0;
    unsigned int frames_buffered = 0;


    //Declare the structure for the function. But we only want this to exist here.
    AlignParms alignment_structure;

    //sanity check on input arguments:
    if( nrhs != 3)
    {
        //Are we OK for numbers?
        mexErrMsgIdAndTxt("optotrakToolbox:optotrak_register_and_align_many_cameras:nrhs","This function need exactly three arguments.");
    }
    if( (!mxIsChar(prhs[0])) || (!mxIsChar(prhs[1])) || (!mxIsChar(prhs[2])) )
    {
        //Is everything a string?
        mexErrMsgIdAndTxt("optotrakToolbox:optotrak_register_and_align_many_cameras:nrhs", "Make sure that all input arguments are strings!");
    }

    //If everything is OK, transfer the input arguments. It's tricky, because we have to use pointers, and we don't know how large are these.
    collection_setup_file = mxArrayToString(prhs[0]);
    path_to_rigid_body = mxArrayToString(prhs[1]);
    output_camera_file = mxArrayToString(prhs[2]);

    mexPrintf("Collection setup file is %s, rigid body file is %s, and the output camera file will be %s.\n", collection_setup_file, path_to_rigid_body, output_camera_file);
    mexEvalString("drawnow;"); //This is Matlab's equivalent of flush(stdout)


    mexPrintf("Step 1: Record with unregistered cameras and unaligned system\n");

    mexPrintf("\tSending a nudge to the system...\n");
    mexEvalString("drawnow;"); //This is Matlab's equivalent of flush(stdout)

    //Start up the system.
    if(TransputerDetermineSystemCfg("transputer_discovery.log"))
    {
        internal_complain_to_me();
    }

    //Add some delay here.
    mexEvalString("pause(2);");

    //Load the system config file, so we know where is the SCU to which we have to communicate to.
    if(TransputerLoadSystem("system"))
    {
        internal_complain_to_me();
    }
    //Add some delay here.
    mexEvalString("pause(2);");
    
    //Now that the system has started, initialise it. Since I am investigating why the system fails with multiple cameras, I am setting this to log FREAKING EVERYTHING!
    if(TransputerInitializeSystem( OPTO_LOG_ERRORS_FLAG | OPTO_LOG_STATUS_FLAG | OPTO_LOG_WARNINGS_FLAG | OPTO_SECONDARY_HOST_FLAG | OPTO_ASCII_RESPONSE_FLAG | OPTO_LOG_MESSAGES_FLAG | OPTO_LOG_DEBUG_FLAG | OPTO_LOG_CONSOLE_FLAG | OPTO_LOG_VALID_FLAGS))
    {
        internal_complain_to_me();
    }
    //Add some delay here.
    mexEvalString("pause(2);");


    //Configure the cameras. At first, load the factory default.
    if(OptotrakLoadCameraParameters("standard"))
    {
        internal_complain_to_me();
    }
    //Add some delay here.
    mexEvalString("pause(2);");

    mexPrintf("\tConfiguring the system using %s\n", collection_setup_file);
    mexEvalString("drawnow;"); //This is Matlab's equivalent of flush(stdout)
    
    //Set up data acquisition from the specified config file
    //Load the system config file, so we know where is the SCU to which we have to communicate to.
    if(!(OptotrakSetupCollectionFromFile(collection_setup_file)))
    {
        internal_complain_to_me();
    }

    //We need to see how the system got initialised.
    if(OptotrakGetStatus(&number_of_sensors, &number_of_odaus, &number_of_rigid_bodies, &number_of_markers, &frame_rate, &marker_frequency, &threshold, &minimum_gain, &are_we_streaming, &marker_duty_cycle, &marker_voltage, &collection_time, &pre_trigger_time, &collection_flags))
    {
        internal_complain_to_me();
    }
/*
    if(number_of_sensors < 5)
    {
        //Make this fail if there is only one sensor detected.
        mexErrMsgIdAndTxt("optotrakToolbox:optotrak_register_and_align_many_cameras:nrhs", "Only a single camera was detected. This file is for many cameras. Use optotrak_align_with_single_camera() instead.");
    }
*/


    mexPrintf("\tSystem initialised. %d cameras, %d markers present, will record at %.2f fps, for %.1f seconds.\n", number_of_sensors/3, number_of_markers, frame_rate, collection_time);
    mexEvalString("drawnow;"); //This is Matlab's equivalent of flush(stdout)
    
    //Add some delay here.
    mexEvalString("pause(2);");

    //Now we can record wth the unaligned data.

    //Iniitalise recording file
    if(DataBufferInitializeFile(OPTOTRAK, "unaligned_unregistered_recording.dat"))
    {
        internal_complain_to_me();
    }
    //Add some delay here.
    mexEvalString("pause(2);");

    //switch on the markers
    if(OptotrakActivateMarkers())
    {
        internal_complain_to_me();
    }
    //Wait a little.
    mexEvalString("pause(2);");
    
    //Start the data collection
    if(DataBufferStart())
    {
        internal_complain_to_me();
    }
    mexPrintf("\tRECORDING NOW!\n");
    mexEvalString("drawnow;"); //This is Matlab's equivalent of flush(stdout)
    
    //wait for the data to be ready in the buffer.
    sprintf(eval_string, "pause(%d);", (int)collection_time+1 );
    mexEvalString(eval_string);
    
    //Stop collecting data. This should not be necessary, as we already delayed.
    if(DataBufferStop())
    {
        internal_complain_to_me();
    }

    //switch off the markers
    if(OptotrakDeActivateMarkers())
    {
        internal_complain_to_me();
    }
    //Wait a little.
    mexEvalString("pause(1);");
    
    //Now that we have the data ready, spool the buffer to the 
    mexPrintf("\tCollection finished, saving file.\n");
    mexEvalString("drawnow;"); //This is Matlab's equivalent of flush(stdout)
    
    


    //We have to wait until this is finished.
    while(!spooling_completed)
    {
        if(DataBufferWriteData(&there_is_data, &spooling_completed, &spool_status, &frames_buffered))
        {
            internal_complain_to_me();
        }
        //mexPrintf("Written out %d frames so far.\n", frames_buffered);
        //mexEvalString("drawnow;");
    }
    mexPrintf("Done! Saved %d frames.\n", frames_buffered);
    mexEvalString("drawnow;");
    //Now that this is done, we need to close the file.
    if(FileClose(0))
    {
        internal_complain_to_me();
    }

    mexPrintf("\tunaligned_unregistered_recording.dat has been saved successfully.\n");
    mexEvalString("drawnow;"); //This is Matlab's equivalent of flush(stdout)

    //Now we can register all the cameras together.
    strcpy(alignment_structure.szDataFile, "unaligned_unregistered_recording.dat");
    strcpy(alignment_structure.szRigidBodyFile, path_to_rigid_body);
    strcpy(alignment_structure.szInputCamFile, "standard");
    strcpy(alignment_structure.szOutputCamFile, output_camera_file);
    strcpy(alignment_structure.szLogFileName, "calibrig.log");

    alignment_structure.nLogFileLevel = 2; // This is the most talkative
    alignment_structure.bInputIsRawData = 1; // I am assuming this is just 'raw' or 'centroid' data, as opposed to 'full raw' or 'centroid + peaks'.
    alignment_structure.bVerbose = 1; // Yes please.
    //Now, we can execute the function.
    
    //This is for debug. Normally you won't need to print this.
    //mexPrintf("Structure fields are:\n\tszDataFile: %s\n\tszRigidBodyFile: %s\n\tszInputCamFile: %s\n\tszOutputCamFile: %s\n\tszLogFileName: %s\n", alignment_structure.szDataFile, alignment_structure.szRigidBodyFile, alignment_structure.szInputCamFile, alignment_structure.szOutputCamFile, alignment_structure.szLogFileName);
    if(nOptotrakAlignSystem(alignment_structure, &tolerance));
    {
        internal_complain_to_me();
    }



    //return values.
    plhs[0] = mxCreateDoubleScalar(fail); //define return value type, and toss it to return.
    plhs[1] = mxCreateDoubleScalar(tolerance); //this tells me how good the new alignment is

}