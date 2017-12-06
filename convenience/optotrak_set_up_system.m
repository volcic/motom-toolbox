function [fail] = optotrak_set_up_system(camera_calibration_file, data_acquisition_config_file)
%OPTOTRAK_SET_UP_SYSTEM
% [fail] = optotrak_set_up_system(camera_calibration_file, data_acquisition_config_file)
% This function loads the specified camera calibration file, loads the camera parameters, and then it sets up data acquisition from a specified ini file.
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
        
    
    %Check if the config file actually exists. If not, fail.
    if(~exist(data_acquisition_config_file))
        fprintf('Config file to use: %s\n', data_acquisition_config_file)
        error('The config file doesn''t exist or it can''t be read. Have you got permissions?');
    end
    %Adjust the config file at will. If you do something wrong, it will crash.  
    if(OptotrakSetupCollectionFromFile(data_acquisition_config_file))
        %If we got here, then something went wrong.
        optotrak_tell_me_what_went_wrong;
        error('OptotrakSetupCollectionFromFile() failed. Check opto.err for details.')
    end

    pause(2); % need to wait.

    %Fetch set-up info for sanity checks.
    setup_struct = optotrak_get_setup_info;
    
     %Added feature: Are we using the correct camera file?

    %A bit of explanation here. The camera file size seems to change with the
    %number of cameras used in the creation of the camera file. However, if you
    %load a camera file that does not match with your set-up, the software will
    %continue and data acquisiton will just simply hang without leaving any
    %error messages. So, this bit of code checks whether the camera file is the
    %correct size is as expected to the initialised system.

    file_info = dir(sprintf('%s*', camera_calibration_file));

    if(length(file_info) == 0)
        %if the file doesn't exist in the specified path, it must be in the
        %ndigital directory. Re check. If it's in the default path, it must
        %only contain the file name. this makes our job easier.
        if(isunix)
            %Linux default path.
            file_info = dir(sprintf('/usr/NDIoapi/ndigital/realtime/%s.cam', camera_calibration_file));
        else
            %Windows default path.
            file_info = dir(sprintf('C:\\ndigital\\realtime\\%s.cam', camera_calibration_file));
        end
        %We should now have the file info.
        if(length(file_info) == 0)
            %Ideally we should never get here.
            warning('The specified camera file could not be found in nethier the given path, nor the default path.\nMake sure your camera file actually works!\nPlease don''t add the ''.cam'' extension!')
        end
    end


    %A camera file with a single camera is 3727 bytes long.
    %When two cameras are used, it's 7303 long.
    %It would be necessary to add more numbers. I only have two cameras.

    camera_calibration_file_sizes = [3727, 7303];

    %Apparently, up to 8 cameras can be used simultaneously. 
    number_of_cameras = round(setup_struct.number_of_sensors / 3);

    %Add a warning if mroe than two cameras are used.
    if(number_of_cameras > 2)
        warning('You seem to use more than two cameras. Please add to camera_calibration_file_sizes in optotrak_set_up_system(), and file MOTOM toolbox issue on github.')
    else
        if(file_info.bytes ~= camera_calibration_file_sizes(number_of_cameras))
            fprintf('Camera file name: %s\n', camera_calibration_file);
            fprintf('Detected number of cameras: %d, expected file size is: %d bytes, actual file size is %d bytes.\n', number_of_cameras, camera_calibration_file_sizes(number_of_cameras), file_info.bytes)
            error('ERROR: Incorrect camera file loaded!')
        end
        %If we got here, all is well. Proceed.
    end
    
    
    %Added feature: Test the set-up while initialising. If you fill the
    %buffer, the data acquisition won't fail, it will just simply overwrite
    %the data. Therefore, it is up to the user to see if the configuration
    %can be stored adequately.
    
    if(~setup_struct.are_we_streaming)
        %If we use the buffer, we have to check if the data will fit in the
        %buffer. NDI wouldn't confirm this, but there is 6 MB of SD RAM in
        %the SCU. Not sure how much of it is used by the SCU's software,
        %so these are just guidelines. However, if more memory is allocated
        %than what is physically present in the SCU, it will be surely
        %impossible to recover the data.

        %This is calculated as per the Optotrak Certus manual. The toolbox
        %buffers 'centroid' or 'raw' data, and everything will be calculated
        %from the saved raw data file. Therefore, we will always know what to
        %buffer, and can calculate how much data will be used.
        memory_required_bytes = ...
            setup_struct.collection_time * ...
            setup_struct.number_of_markers * ...
            setup_struct.frame_rate_in_fps * ...
            setup_struct.number_of_sensors * 4;

        fprintf('Required buffer size is %.3f MB.\n', memory_required_bytes / (1024 * 1024))

        %If we are exceeding 6 MB, fail initialisation.
        if(memory_required_bytes > 6291456)
            fprintf('\nData collection time: %d seconds\n', setup_struct.collection_time);
            fprintf('Frame rate: %.3f Hz\n', setup_struct.frame_rate_in_fps);
            fprintf('Number of markers: %d\n', setup_struct.number_of_markers);
            fprintf('Number of sensors: %d\n', setup_struct.number_of_sensors);
            fprintf('Total buffer memory needed: %.3f MB.\n', memory_required_bytes / (1024 * 1024))
            error('System initialisation error: Buffered data will be overwritten before the end of collection time!')
        end


        %Throw a warning about 4 MB.
        if(memory_required_bytes > 4194304)
            fprintf('\nData collection time: %d seconds\n', setup_struct.collection_time);
            fprintf('Frame rate: %.3f Hz\n', setup_struct.frame_rate_in_fps);
            fprintf('Number of markers: %d\n', setup_struct.number_of_markers);
            fprintf('Number of sensors: %d\n', setup_struct.number_of_sensors);
            fprintf('Total buffer memory needed: %.3f MB.\n', memory_required_bytes / (1024 * 1024))
            warning('This configuration uses more than 4 MB of buffer memory. Proceed with caution!')
        end
    end
    
   


    
    
    %Feature request: turn on markers after initialising the system.
    OptotrakActivateMarkers;
    fail = 0; % return value, just in case.
end