function [fail] = optotrak_set_up_system(camera_calibration_file, data_acquisition_config_file)
%OPTOTRAK_SET_UP_SYSTEM This function loads the specified camera calibration file, loads the camera parameters, and then it sets up data acquisition from a specified ini file.
% Input arguments are:
%   -> camera_calibration_file is a file in your ndigital directory by default. Don't use the extension, just the name
%   -> data_acquisition_config_file is the ini file you edited/generated.
% fail is 0 upon success, and the function terminates with an error message if something went wrong.


    if(nargin ~= 2)
        error('you must specify two config files. One is the camera parameter file, the other one is the data acquisition setting .ini file.')
    end

    %now we toss the parameters in

    % If you have a custom camera calibration file, specify it here:
    if(OptotrakLoadCameraParameters(camera_calibration_file))
        optotrak_tell_me_what_went_wrong;
        error('OptotrakLoadCameraParameters() failed. Bad/non-existent camera file?')
    end
        
    pause(2); % need to wait.
        
    %Adjust the config file at will. If you do something wrong, it will crash.
    if(OptotrakSetupCollectionFromFile(data_acquisition_config_file))
        %If we got here, then something went wrong.
        optotrak_tell_me_what_went_wrong;
        error('OptotrakSetupCollectionFromFile() failed. Check opto.err for details.')
    end

    fail = 0; % return value, just in case.
end