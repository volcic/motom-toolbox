%This script shows how to use the toolbox, to get real-time position data
%from individual markers.

clear all;
clc;

%% Compensate for not having my own computer.
current_dir = pwd;
cd ../..
add_toolbox_to_path; %this is here because I can't add the toolbox path permanently on this computer.
cd(current_dir);
%% Initialise the hardware.
optotrak_startup(); %note that this takes several seconds to execute.

% If you have a custom camera calibration file, specify it here:
calibration_file = 'standard';
% Add the config file here:
data_acquisition_config_file = 'stream_real_time_data_with_blocking';
optotrak_set_up_system(calibration_file, data_acquisition_config_file);

%If you have a peculiar strober set-up, you can specify how many IR LEDs
%are connected to which port of the SCU:

%OptotrakSetStroberPortTable(6, 0, 0, 0); % Port 4 is not available in the Certus system.


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





%% Collect 10 frames of data.
%You don't need to turn the markers on and off all the time. I just did
%this for neatness.

OptotrakActivateMarkers(); %this turns on the IR LEDs
%we need to wait 5 frames after this.
pause((1/frame_rate)*5);

%pre-allocate variables
frames = zeros(1, 10);
positions = zeros(10, markers*3); %I initialised this to have 3 markers.
flags = zeros(1, 10);

for(i=1:10)
    % Invisible markers will be NaN.
    [~, frames(i), positions(i, :), flags(i)] = DataGetNext3D_as_array; %You can use this script in the render loop.
end
OptotrakDeActivateMarkers(); % turn off the IR LEDs

%% shut down the system
%optotrak_kill; 

fprintf('The data is left in frames(:), positions(:,:), and flags(:)\n')





