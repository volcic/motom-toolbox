% Example simple experiment file.
% Capturing real-time position3d data, and organised into trials.

clear all;
clc;

%% Preparation!
% IMPORTANT: Align your coordinate system to your own experimental rig.
% Connect the NDI cube, and execute the following function:
%tolerance = optotrak_align_my_system('this_works_with_the_ndi_cube.ini','ndi_cube.rig') %These are with the included files. 

%% Let's get started:

camera_file = 'standard'; %Replace this with the camera file you generated.
config_file = 'example_simple_config_file.ini'; %Check this file to see what happens here.

number_of_trials = 5;
number_of_frames_per_trial = 50;

optotrak_startup;
optotrak_set_up_system(camera_file, config_file);

%% Begin collecting data.
OptotrakActivateMarkers;

fprintf('Welcome to the simple experiment!\nThis code collects data in %d trials, and the trials contain %d frames of data.\n', number_of_trials, number_of_frames_per_trial);

for(i=1:number_of_trials)
    fprintf('Press Enter in the command window to start trial %d!\n', i)
    pause();
    for(j=1:number_of_frames_per_trial)
        %Each of this is going to be a new frame.
        [fail, framecounter(i, j), position3d_array(i, j, :), flags(i, j)] = DataGetNext3D_as_array();
        %So a bit of what's what here.
        % -fail is an error indicator. Nonzero value indicates something
        %   went wrong.
        % -framecounter is the number of frame since data acquisition
        %   began, effectively from when calling OptotrakActivateMarkers();
        % -position3d_array is where the coordinates of the markers go. In
        %   this case, it's a 3D array. The first dimension is the number
        %   of trial, the second dimension each frame within a trial, and
        %   the third dimension is where the coordinates go in X-Y-Z
        %   triplets for each marker. Units are in millimetres.
        % -flags is the data acquisition flag. You can use
        %   optotrak_data_flag_decorer() to find out what these are, but
        %   you won't need this during normal use.
        
    end
end

%% Dazzle the user with some preliminary data.

trial_to_plot = round(rand(1)*(number_of_trials-1)) + 1; %Come up with a random number

fprintf('Experiment done! The results are stored in the ''position3d_array'' variable. As an example, let''s plot trial %d!\n', trial_to_plot);

optotrak_plot_marker_positions(squeeze(position3d_array(trial_to_plot, :, :))); %Internal plotter script. For indication only.

%that's it!
optotrak_kill; %This will shut down the system gracefully, and unloads the libraries.