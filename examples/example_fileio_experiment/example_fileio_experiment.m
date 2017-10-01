% Example experiment with File IO. It saves every trial as raw data file,
% and then, after the experiment, we re-initialise the system, and will
% convert the raw data to position 3d data you can process.

%You might ask, why do you want to do this? There are several advantages of
%storing data this way:
% 1., Raw data requires the least amount of processing to save
% 2., The extracted positions can change with the camera file you are
%     upoloading while converting the raw data
% 3., You can process everything later, including your rigid body
%     transforms or defintions

clear all;
clc;

%If you are repeating this, clean up first
if(isunix)
    system('rm *.log');
    system('rm data/*.dat');
else
    system('del *.log');
    %Windows.
    cd('data')
    system('del *.dat');
    cd('..');
    
end


%% Preparation!
% IMPORTANT: Align your coordinate system to your own experimental rig.
% Connect the NDI cube, and execute the following function:
%tolerance = optotrak_align_my_system('this_works_with_the_ndi_cube.ini','ndi_cube.rig') %These are with the included files. 

%% Let's get started:
% some diagnostic variables here.
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



camera_file = 'standard'; %Replace this with the camera file you generated.
config_file = 'example_fileio_config_file.ini'; %Check this file to see what happens here.
number_of_trials = 5;


optotrak_startup;
optotrak_set_up_system(camera_file, config_file);
OptotrakActivateMarkers; %Turn on the markers here.

%% Experimental loop.
for(i = 1:number_of_trials)
    %First of all, generate the file names.
    file_names{i} = sprintf('data/trial%03d_raw.dat', i) %Note that this is a cell array
    
    DataBufferInitializeFile(0, file_names{i}); % 0 means Optotrak. Can be ODAU(1...4) (by adding 2...5)
    
    fprintf('Trial %d: Data buffer file created. Press Enter to start the trial.', i)
    pause;
    
    DataBufferStart; %This starts the actual recording.
    fprintf('RECORDING TRIAL %d/%d!\n', i, number_of_trials)
    % Do nothing here. But, while buffering, you can do other things.
    %In this case, we read out system status, so we know how long is a trial.
    [fail, sensors, odaus, rigid_bodies, markers, frame_rate, marker_frequency, threshold, gain, are_we_streaming, duty_cycle, voltage, collection_time, pretrigger_time, flags] = OptotrakGetStatus(sensors, odaus, rigid_bodies, markers, frame_rate, marker_frequency, threshold, gain, are_we_streaming, duty_cycle, voltage, collection_time, pretrigger_time, flags);

    pause(collection_time); %We wait until the trial is over.

    fprintf('Saving file (%s)...', file_names{i});
    optotrak_stop_buffering_and_write_out;
    fprintf('Done!')
end
fprintf('Experiment finished.\n')
OptotrakDeActivateMarkers; %Turn off the markers.

%% OPTIONAL: Re-set the system. This shows that files can be read.
optotrak_kill;

optotrak_startup;
%You can load a different config file and camera file here, if you want.
%camera_file = 'standard'; %Replace this with the camera file you generated.
%config_file = 'example_simple_config_file.ini'; %Check this file to see what happens here.
optotrak_set_up_system(camera_file, config_file);

%% Reload the raw files, and convert them to positions that mere mortals like ourselves can process.

%Again, loop through all the trials.
for(i = 1:number_of_trials)
    %Positions:
    % -First dimension is the number of trials.
    % -Second dimension is the number of frames within a trial
    % -Third dimension is the coordinates, in X-Y-Z triplets, for each
    %  marker. This is just an example format, you don't have to adhere to
    %  this.
    
    [fail, position3d_array(i, :, :)] = optotrak_convert_raw_file_to_position3d_array( sprintf('data/trial%03d_raw.dat', i) );
    
    if(fail)
        optotrak_tell_me_what_went_wrong; %this fetches the diagnostic string. If there is any.
        error('Coudln''t obtain the 3D coordinates from the raw data file.\n');
    end
end

%% Dazzle the user with some preliminary data.

trial_to_plot = round(rand(1)*(number_of_trials-1)) + 1; %Come up with a random number

fprintf('Experiment done! The results are stored in the ''position3d_array'' variable. As an example, let''s plot trial %d!\n', trial_to_plot);

optotrak_plot_marker_positions(squeeze(position3d_array(trial_to_plot, :, :))); %Internal plotter script. For indication only.

%that's it!
optotrak_kill; %This will shut down the system gracefully, and unloads the libraries.