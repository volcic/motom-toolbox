function [ fail ] = optotrak_prep_to_record_no_rigid_bodies( os )
%OPTOTRAK_PREP_TO_RECORD_NO_RIGID_BODIES This function sets up the Optotrak system in perhaps the
%most simple way. All markers are tracked, no rigid bodies, recording for a fixed time, streaming data directly. Simple.
%   Everything is stored in the optotrak structure (os), fields are
%   assinged as follows:


    [fail, ~, ~, ~, ~] =  OptotrakSetStroberPortTable(os.port1_markers, os.port2_markers, os.port3_markers, os.port4_markers);
    if(fail)
        error('OptotrakSetStroberPortTable() failed.')
    end
    number_of_markers = os.port1_markers + os.port2_markers + os.port3_markers + os.port4_markers;
    
    %We need to load the camera parameter file first.
    if(OptotrakLoadCameraParameters(os.camera_calibration_file));
        error('OptotrakLoadCameraParameters() failed. The settings didn''t load.')
    end

    if(os.use_highest_framerate)
        framerate = 4600 / (number_of_markers + 2);
    end
    
    %now we can set up the Optotrak system.
    
    %if we survived for this long, we didn't fail. Therefore,
    fail = 0;
end

