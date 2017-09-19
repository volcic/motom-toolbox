%This script shows how to use the toolbox, to get buffered position data
%from individual markers.

clear all;
clc;

%% Compensate for not having my own computer.
current_dir = pwd;
cd ../..
add_toolbox_to_path; %this is here because I can't add the toolbox path permanently on this computer.
cd(current_dir);
%TransputerShutdownSystem; %make sure the system is not initialised.

%% Initialise the hardware.
optotrak_startup(); %note that this takes several seconds to execute.
pause(1); % need to wait.

% If you have a custom camera calibration file, specify it here:
calibration_file = 'standard';
%Adjust the config file at will. If you do something wrong, it will crash.
data_acquisition_config_file = 'buffer_data_with_120089_cube';

optotrak_set_up_system(calibration_file, data_acquisition_config_file);

%If you have a peculiar strober set-up, you can specify how many IR LEDs
%are connected to which port of the SCU:

%OptotrakSetStroberPortTable(6, 0, 0, 0); % Port 4 is not available in the Certus system.
pause(1); % need to wait.

% Add the rigid body.
if(RigidBodyAddFromFile_euler(0, 1, 'CU-01209')) %If you have more markers, you can offset them here.
    optotrak_tell_me_what_went_wrong;
    error('RigidBodyAddFromFile_euler() failed. Couldn''t add rigid body.')
end


%% Just for fun, print out what did we initialise.
%You don't really need to see this, but you can correspond this to the
%config file. Or use OptotrakSetupCollection()
fail = 0;
sensors = 0;
odaus = 0
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


[fail, sensors, odaus, rigid_bodies, markers, frame_rate, marker_frequency, threshold, gain, are_we_streaming, duty_cycle, voltage, collection_time, pretrigger_time, flags] = OptotrakGetStatus(sensors, odaus, rigid_bodies, markers, frame_rate, marker_frequency, threshold, gain, are_we_streaming, duty_cycle, voltage, collection_time, pretrigger_time, flags)


optotrak_device_flag_decoder(flags)

%% Get the buffered data!
%initialise the buffer file
[fail, ~] = DataBufferInitializeFile(0, 'buffered_cube_markers_raw.dat');
if(fail)
    optotrak_tell_me_what_went_wrong;
    error('Couldn''t open file. Have you got permissions?')
end



OptotrakActivateMarkers(); %this turns on the IR LEDs
%we need to wait 5 frames after this.
pause((1/frame_rate)*5);

fprintf('RECORDING NOW....\n')
DataBufferStart; % begin buffering

% Wait for the acquitision time to go. You can do other things here in your
% code, for example, you can monitor your code real-time

%pre-allocate variables
frames = zeros(1, 10);
positions = zeros(10, markers*3); %I initialised this to have 3 markers.
translation = zeros(10, rigid_bodies*3); %X-Y-Z triplet
rotation = zeros(10, rigid_bodies*3); %Roll-pitch-yaw triplet
flags = zeros(1, 10);

for(i=1:1500)
    % Invisible markers will be NaN.
    [~, frames(i), translation(i, :), rotation(i,:), positions(i, :), flags(i)] = DataGetNextTransforms2_as_array(markers); %You can use this script in the render loop.
end

OptotrakDeActivateMarkers(); % turn off the IR LEDs


fprintf('Writing out buffer NOW.\n')
optotrak_stop_buffering_and_write_out;

%% convert raw data.

% Just because this data set has a rigid body, we still can get the marker positions:

[fail, positions_from_file1] = convert_raw_file_to_position3d_array('buffered_cube_markers_raw.dat');

% ...and also, we now can get the rigid body transforms out as well.
[fail, positions_from_file2, translations_from_file, rotations_from_file] = convert_raw_file_to_rigid_euler_array('buffered_cube_markers_raw.dat');

%% Gracefully shut down.
optotrak_kill;

% Add a message to see what happened
fprintf('After finishing everything:\n');
fprintf('-''positions'' should be the same as ''positions_from_file1'' and ''positions_from_file2''\n');
fprintf('-''translations'' should be the same as ''translations_from_file''\n');
fprintf('-''rotations'' should be the same as ''rotations_from_file''\n');