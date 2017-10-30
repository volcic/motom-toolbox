% Adcanced experiment. We are collecting data with the buffer, and taking a
% look at the real-time data while we are recording. This is useful when
% the experiment uses position data in the trial.

% NOTE: Miscellaneous stuff such as random inteleaving, subject data and
% others are not included. This example shows how to drive the Optotrak
% system, and nothing more. It is your responsilibity to to make sure your
% experiment works correctly!

%make sure we are working with a clean environment.
clear all;
clc;

%% Coordinate system alignemnt
% NOTE: Use your own calibration/alignemnt file, or create your own by uncommenting these lines.

% cd alignment;
% 
% %Plug the NDI cube in to Port 1 of the SCU. Of course, you can use your
% %own device as well, change the rigid body file accordingly.
% optotrak_align_my_system('this_works_with_the_ndi_cube.ini', 'ndi_cube.rig');
% 
% cd ..;



% Use these files here.

%camera_file = 'standard'; %This is the factory-supplied camera file.
camera_file = 'alignment/Aligned_2017-10-30_12-31.cam';
config_file = 'example_advanced_experiment.ini';

%% Initialise the system.
% file names, length, etc.
number_of_trials = 5000;
temp_data_file = 'data/temp.dat'; % This will contain the raw data for a single trial
buffered_data = struct; %this will hold the recorded buffered data
real_time_data = struct; %This will hold the recorded real-time data
trial_frame_pointer = 1; %This is the number of real-time frames recorded within a trial



% Touch the Optotrak system.
optotrak_startup; %this loads the library and wakes up the Optotrak system
optotrak_set_up_system(camera_file, config_file); %This loads the coordinate system alignent data, and loads the config file by which the system should operate.
% The markers are now on, and the data can be collected.
fprintf('Optotrak system initialised.\n')

% Prior to starting any data collection, it's useful to call a real-time
% data function.
[fail, framecounter, single_frame_position3d, flags] = DataGetNext3D_as_array;
clear fail framecounter single_frame_position3d flags;

%Load the data collection settings in a structure.
data_acquisition_settings = optotrak_get_setup_info;
%Normally you won't need this, but this is a useful tool to verify whether
%the settings you specified in the config file correctly loads into the system.

%For example, we can calculate the number of frames per trial:
number_of_frames_per_trial = data_acquisition_settings.frame_rate_in_fps * data_acquisition_settings.collection_time; %This should always be a round number.

%% Begin the experiment
 
for(i = 1:number_of_trials)
    %Experimental loop
    fprintf('Trial %d begins, ', i)
    DataBufferInitializeFile(0, temp_data_file); % 0 means we are collecting data from the Optotrak
    fprintf('data buffer now initialised.\n')
    DataBufferStart; %This starts the actual recording
    fprintf('RECORDING NOW! This will take %d seconds.\n', data_acquisition_settings.collection_time);
    %While we are buffering, we can have access to the real-time data.
    recording_trial = 1; %This is a flag for the real-time loop to execute
    trial_frame_pointer = 1; %This variable is used to fill-in the arrays
    while(recording_trial)
        %real-time loop.
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        % WARNING:
        % This loop might execute faster or slower than the frame rate!!!
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %If this loop is faster than the frame reate, replace
        %DataGetLatest3D_as_array to DataGetNext3D_as_array. Otherwise you
        %will get duplicate data.
        
        %If this loop is slower than the frame rate, you will not be able
        %to access all the frames directly using real-time data. Consult
        %the framecounter field in the real_time_data structure.
        
        %Within this loop, you can handle real-time data. 
        tic; %measure time as well.
        
        %If this loop executes slower slower than the frame rate, use this:
        [fail, real_time_data.(sprintf('trial_%d', i)).framecounter(trial_frame_pointer), real_time_data.(sprintf('trial_%d', i)).positions(trial_frame_pointer, :), ~ ] = DataGetLatest3D_as_array;
        %If this loop executes faster than the frame rate, use this:
        %[fail, real_time_data.(sprintf('trial_%d', i)).framecounter(trial_frame_pointer), real_time_data.(sprintf('trial_%d', i)).positions(trial_frame_pointer, :), ~ ] = DataGetNext3D_as_array;
        
        real_time_data.(sprintf('trial_%d', i)).execution_time(trial_frame_pointer) = toc; %This is for perfomance checking. You won't need this.

        %Calculate how many frames are we skipping
        frame_skip = round(mean(diff( real_time_data.(sprintf('trial_%d', i)).framecounter ))); 
        
        
        %have we finished the trial?
        if(real_time_data.(sprintf('trial_%d', i)).framecounter(trial_frame_pointer)  >= ((number_of_frames_per_trial * i) - frame_skip) )
            %If we got here, it means that the system has collected enough
            %frames for a single trial
            recording_trial = 0;
        else
            % if not, keep in the loop.
        
            trial_frame_pointer = trial_frame_pointer + 1; %Offset this pointer by one.
        end
        
    end
    
    %Once the buffer finished, we can 'spool' the data from the buffer into
    %the temporary file.
    optotrak_stop_buffering_and_write_out;
    fprintf('Recording ended.\n')
    % Now we need to convert the raw data to positions. We also save it to
    % a structure, nice and neat.
    [ fail, buffered_data.(sprintf('Trial_%d', i)) ] = optotrak_convert_raw_file_to_position3d_array(temp_data_file);
    if(fail)
        %Assuming the file is intact, you should never get here.
        optotrak_tell_me_what_went_wrong; %This writes out the last error message from the system
        error('Couldn''t convert the raw data file to positions.')
    end
    
    %fprintf('Press Enter in the command window to start the next trial.')
    pause(0.5); %Press a key for the next trial.
end

%% Finito.

save('data/real_time.mat', 'real_time_data')
save('data/buffered.mat', 'buffered_data')

fprintf('Experiment finished. Data is in the real_time and buffered_data structures, which are saved in the data directory.\nHowever, there is more to this, so please read the comments and the additional documentation!\n')

optotrak_kill; %This unloads the librries and shuts down the Optotrak system.


%% Diagnostics.

close all;

%framecounter values
figure;
for(i=1:number_of_trials)
plot(real_time_data.(sprintf('trial_%d', i)).framecounter(:))
hold on;
title('framecounter value')
xlabel('frames in the trial')
ylabel('returned framecounter value')
end

% Frame skips
figure;
for(i=1:number_of_trials)
plot(diff(real_time_data.(sprintf('trial_%d', i)).framecounter(:)))
hold on;
title('frame skips')
xlabel('frames in the trial')
ylabel('frame skips in the real-time loop')
end

% Execution time
figure;
for(i=1:number_of_trials)
plot(real_time_data.(sprintf('trial_%d', i)).execution_time(:) * 1000)
hold on;
title('execution time for DataGetLatest3D()');
xlabel('frames in the trial')
ylabel('execution time [ms]')
end

