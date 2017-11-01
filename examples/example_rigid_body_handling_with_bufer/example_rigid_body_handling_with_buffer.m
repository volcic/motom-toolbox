%This script shows how to handle a rigid body via buffering. For the sake
%of simplicity, we will use the same NDI cube the coordinate system was
%aligned with.

%   -Initialisation
%   -Load the rigid body
%   -We record some raw data (experimental and real-time loops)
%   -Convert raw data to rigid body transforms and positions

clear all;
clc;

%% Alignemnt.

%If you haven't already done so, please align your coordinate system, by
%executing this line below.
%optotrak_align_my_system('this_works_with_the_ndi_cube.ini', 'ndi_cube.rig');


%% Initialisation

config_file = 'example_rigid_body_handling_with_buffer.ini';
%camera_file = 'standard'; %if you want, you can use the default coordinate system.
camera_file = 'Aligned_2017-10-30_12-31.cam'; %my custom camera file. Generate yours!

temp_data_file = 'data/temp_raw.dat'; %This will be the raw data.

number_of_trials = 10;

optotrak_startup;
optotrak_set_up_system(camera_file, config_file);

%Load the data collection settings in a structure.
data_acquisition_settings = optotrak_get_setup_info;
%Normally you won't need this, but this is a useful tool to verify whether
%the settings you specified in the config file correctly loads into the system.

%Now the system is initialised, and is ready to go.

number_of_frames_per_trial = data_acquisition_settings.frame_rate_in_fps * data_acquisition_settings.collection_time;

fprintf('Optotrak system initialised.\n');
%% Load the rigid body

fail = RigidBodyAddFromFile_euler(0, 1, 'ndi_cube.rig'); %0 is the rigid body ID, 1 is the first marker of the rigid body

%error management. Optional, but can help occasionally.
if(fail)
    optotrak_tell_me_what_went_wrong;
    error('Couldn''t add rigid body. Check opto.err for details.')
end

fprintf('Rigid body file loaded.\n')
%% Experimental loop

for(i=1:number_of_trials)
    fprintf('Trial %d/%d:\n', i, number_of_trials)
    DataBufferInitializeFile(0, temp_data_file); %0 means that we are recording Optotrak data
    fprintf('Buffer file initalised, ');
    
    DataBufferStart; %This starts the actual recording
    %Bounce up the framecounter before going to the real-time loop.
    [~, ~, ~, ~, ~] = DataGetNextTransforms2_as_array(0); %0 means that we don't want any position data.
    
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
        [fail, real_time_data.(sprintf('trial_%d', i)).framecounter(trial_frame_pointer), real_time_data.(sprintf('trial_%d', i)).translation(trial_frame_pointer, :), real_time_data.(sprintf('trial_%d', i)).rotation(trial_frame_pointer, :), real_time_data.(sprintf('trial_%d', i)).positions(trial_frame_pointer, :)] = DataGetLatestTransforms2_as_array(data_acquisition_settings.number_of_markers); %The number of markers are not required, but then you won't get the position data back.
        %If this loop executes faster than the frame rate, use this:
        %[fail, real_time_data.(sprintf('trial_%d', i)).framecounter(trial_frame_pointer), real_time_data.(sprintf('trial_%d', i)).translation(trial_frame_pointer), real_time_data.(sprintf('trial_%d', i)).rotation(trial_frame_pointer), real_time_data.(sprintf('trial_%d', i)).positions(trial_frame_pointer)] = DataGetNextTransforms2_as_array(data_acquisition_settings.number_of_markers); %The number of markers are not required, but then you won't get the position data back.
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
    
    %This next line fetches the marker positions, and the rigid body
    %tranforms as well. Note that it only works with a properly initialised
    %system.
    [ fail, buffered_data.(sprintf('Trial_%d', i)).positions, buffered_data.(sprintf('Trial_%d', i)).translation, buffered_data.(sprintf('Trial_%d', i)).rotation] = optotrak_convert_raw_file_to_rigid_euler_array(temp_data_file);
    if(fail)
        %Assuming the file is intact, you should never get here.
        optotrak_tell_me_what_went_wrong; %This writes out the last error message from the system
        error('Couldn''t convert the raw data file to positions and rigid body transforms.')
    end
   
    fprintf('Rigid body conversion was finished.\n')
    
    %fprintf('Press Enter in the command window to start the next trial.')
    pause(0.5); %Press a key for the next trial.
   
    
    
end
%% Finito.

save('data/real_time.mat', 'real_time_data', '-v7.3'); %The last argument is to make sure large files can be saved.
save('data/buffered.mat', 'buffered_data', '-v7.3'); %The last argument is to make sure large files can be saved.

fprintf('Experiment finished. Data is in the real_time and buffered_data structures, which are saved in the data directory.\nHowever, there is more to this, so please read the comments and the additional documentation!\n')

optotrak_kill; %This unloads the libraries and shuts down the Optotrak system.


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
title('execution time for DataGetLatestTransforms2()');
xlabel('frames in the trial')
ylabel('execution time [ms]')
end

    
