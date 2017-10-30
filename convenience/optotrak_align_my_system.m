function [ total_rms_error ] = optotrak_align_my_system( config_file, rigid_body_file )
%OPTOTRAK_ALIGN_MY_SYSTEM
% [ total_rms_error ] = optotrak_align_my_system( config_file, rigid_body_file )
% This function detects what hardware do you have,
%and it performs the necessary registration and alignment.
% Input arguments are:
%   -> config_file is the data acquisition settings .ini file.
%   -> rigid_body_file is the rigid body definition you are using to register and/or align with.
% total_rms_error is the error introduced by the coordinate system
% operations.

    %do a bit of sanity check first
    if(nargin ~= 2)
        error('This function must have exactly two arguments.')
    end

    alignment_recording_file = sprintf('recording_used_for_alignment_%s.dat', datestr(now, 'yyyy-mm-dd_HH-MM')); %This is a raw data file, stored in this local directory.
    registration_recording_file = sprintf('recording_used_for_registration_%s.dat', datestr(now, 'yyyy-mm-dd_HH-MM')); %This is a raw data file, stored in this local directory.
    registration_camera_file = sprintf('Registered_%s.cam', datestr(now, 'yyyy-mm-dd_HH_MM')); %If you have many cameras, we will have to generate this file too.
    registration_logfile_name = sprintf('Registered_%s.log', datestr(now, 'yyyy-mm-dd_HH_MM')); %If you have many cameras, we will have to generate this file too.
    alignment_camera_file = sprintf('Aligned_%s.cam', datestr(now, 'yyyy-mm-dd_HH-MM')); %When everything is finished, this is what you will have to use.
    alignment_logfile_name = sprintf('Aligned_%s.log', datestr(now, 'yyyy-mm-dd_HH-MM')); %This is a raw data file, stored in this local directory.

    %This will be the output of the function, otherwise just a bare fprintf.
    registration_rms_error = 0; %There will be an error when you register the two cameras together.
    alignment_rms_error = 0; %There will be an error when you re-align the coordinate system.
    total_rms_error = 0; %...and there will be a total error, which will be the two combined.

    %% Clean up. As of API version 3.15, the API functions generate a ton of different files.
    
    if(isunix)
        system('rm *.dat');
        system('rm *.XPT');
        system('rm *.XWK');
        system('rm *.WRK');
        system('rm *.log');
    else
        system('del /F /q *.dat');
        system('del /F /q *.XPT');
        system('del /F /q *.XWK');
        system('del /F /q *.WRK');
        system('del /F /q *.log');
    end
    
    

    %% Breathe some life into the system and initialise it properly.

    optotrak_startup; %Do the reset dance. Make the system beep.
    optotrak_set_up_system('standard', config_file); %Load the settings.
    % We need to know how the system is initialised. It's in the config file,
    % but let's load it here.
    fail = 0;
    sensors = 0;
    odaus = 0;
    rigid_bodies = 0;
    markers = 0;
    frame_rate = 0;
    marker_frequency = 0;
    threshold = 0;
    gain = 0;
    are_we_streaming = 0;
    duty_cycle = 0;
    voltage = 0;
    collection_time = 0;
    pretrigger_time = 0;
    flags = 0;


    [fail, sensors, odaus, rigid_bodies, markers, frame_rate, marker_frequency, threshold, gain, are_we_streaming, duty_cycle, voltage, collection_time, pretrigger_time, flags] = OptotrakGetStatus(sensors, odaus, rigid_bodies, markers, frame_rate, marker_frequency, threshold, gain, are_we_streaming, duty_cycle, voltage, collection_time, pretrigger_time, flags);

    if(fail)
        optotrak_tell_me_what_went_wrong;
        error('OptotrakGetStatus failed. Check opto.err for details.')
    end
    
    if(are_we_streaming)
        error('Configuration error: You need to make sure you are not streaming!')
    end


    number_of_cameras = ceil(sensors /3); % One camera module has three sensors. At least on the Certus System I have. If you have something weird with more or less sensors, I compensated for it here.
    fprintf('Detected number of cameras: %d.\n', number_of_cameras);
    number_of_frames = round(frame_rate * collection_time);

    %% If we have many cameras, we need to register them together, and re-initialise the system with the new camera file.
    if(number_of_cameras > 1)
        use_the_registered_cam_file = 1;
        [fail, ~] = DataBufferInitializeFile(0, registration_recording_file); % '0' stands for optotrak. Can be ODAU1...4 (2...5)
        if(fail)
            optotrak_tell_me_what_went_wrong;
            error('Couldn''t open file. Have you got permissions?')
        end
        fprintf('Data buffer file created.\n')

        OptotrakActivateMarkers(); %Now we turn on the markers.
        fprintf('As you have more than one camera, you will need to register them together. This requires the rigid body to be moved about in a volume.\n')
        fprintf('There will be a countdown in a dialogue box. When this dialogue box disappears, the recording begins. When the dialog box re-appears, the recording has finished.\n')
        fprintf('Press Enter in the command window to continue.\n');
        pause();

        messagebox_handle = msgbox(''); %This creates an empty messagebox.
        set(findobj(messagebox_handle,'style','pushbutton'),'Visible','off'); %This gets rid of the OK button
        for(i=5:-1:1) %Countdown loop!
            set(findobj(messagebox_handle,'Tag','MessageBox'),'String',sprintf('The recording will begin in: %d', i) );
            pause(1);
        end
        delete(messagebox_handle); % kill the messagebox.
        fprintf('RECORDING NOW! MOVE THAT BODY!!!! :)\n')
        DataBufferStart();
        %While recording, just print some dots.
        for(i=1:number_of_frames)
            pause(1/frame_rate); 
            if(~mod(i, number_of_frames/10))
                fprintf('.')
            end
        end
        optotrak_stop_buffering_and_write_out; %save the buffer to the data file we allocated.
        pause(2); %Wait a bit here.
        OptotrakDeActivateMarkers();
        optotrak_kill;
        messagebox_handle = msgbox('\nRecording finished, data saved.'); %This creates an empty messagebox.
        set(findobj(messagebox_handle,'style','pushbutton'),'Visible','off'); %This gets rid of the OK button
        pause(5);
        delete(messagebox_handle)
        pause(2)
        %Now we can perform the registration.
        optotrak_startup;

        fprintf('Now starting the multi-camera alignment process. This is going to take a while...\n')

        % Call our helper function.
        [fail, registration_rms_error] = optotrak_register_system_dynamic('standard', registration_recording_file, rigid_body_file, registration_camera_file, registration_logfile_name);
        if(fail)
            optotrak_tell_me_what_went_wrong;
            optotrak_kill;
            error('Calibration failed.')
        end

        fprintf('Error introduced by registering all the cameras together: %.3f mm.\n', registration_rms_error)

        %% After the registration, we need to re-initialise the system with the newly generated registered camera file.

        optotrak_startup; %Do the reset dance. Make the system beep.
        optotrak_set_up_system(registration_camera_file, config_file); %Load the settings, but this time with the newly generated, registered but unaligned camera file!
        %As we are using the same settings, there is no need for a sanity check
        %and effectively now we continue with the alignment routine. With one
        %exception.

        fprintf('Please place back the object to its home position, and press Enter in the command window.\n')
        pause; %wait for the object placement, and continue.
    else
        %Effectively, proceed as normal.
        use_the_registered_cam_file = 0;
    end

    %% Alignment: Record with a carefully placed stationary rigid body.
    [fail, ~] = DataBufferInitializeFile(0, alignment_recording_file); % '0' stands for optotrak. Can be ODAU1...4 (2...5)
    if(fail)
        optotrak_tell_me_what_went_wrong;
        error('Couldn''t open file. Have you got permissions?')
    end
    fprintf('Data buffer file created.\n')

    OptotrakActivateMarkers(); %Now we turn on the markers.

    %Do a countdown.
    fprintf('Waiting 5 seconds. Don''t move anything, and stay out of the way so the camera can see all the markers!\n')
    pause(2);
    fprintf('3\n')
    pause(1);
    fprintf('2\n')
    pause(1);
    fprintf('1\n')
    pause(1);
    fprintf('RECORDING NOW!\n')
    DataBufferStart(); %Begin recording

    %While recording, just print some dots.
    for(i=1:number_of_frames)
        pause(1/frame_rate); 
        if(~mod(i, number_of_frames/10))
            fprintf('.')
        end
    end
    fprintf('\n')

    optotrak_stop_buffering_and_write_out; %save the buffer to the data file we allocated.
    OptotrakDeActivateMarkers();
    optotrak_kill;
    pause(2); %Wait a bit here.

    %% Alignment: Genreate new camera file;

    optotrak_startup;

    % Call our helper function, depending on what we used.
    if(use_the_registered_cam_file)
        %We performed registration, need that camera file.
        [fail, alignment_rms_error] = optotrak_align_coordinate_system(registration_camera_file, alignment_recording_file, rigid_body_file, alignment_camera_file, alignment_logfile_name);
    else
        %Factory unaligned camera file will do.
        [fail, alignment_rms_error] = optotrak_align_coordinate_system('standard', alignment_recording_file, rigid_body_file, alignment_camera_file, alignment_logfile_name);
    end
    if(fail)
        optotrak_tell_me_what_went_wrong;
        optotrak_kill;
        error('Alignment failed.')
    end

    total_rms_error = sqrt( (alignment_rms_error^2) + (registration_rms_error^2) );

    fprintf('Alignment complete.\nYou now can use %s as your camera file in the experiment, and the alignment error is %.2f mm.\n', alignment_camera_file, total_rms_error);
    
    if(total_rms_error >= 0.6)
        warning('The total RMS error seems to be too large. This can cause problems with tracking accuracy.')
    end

end

