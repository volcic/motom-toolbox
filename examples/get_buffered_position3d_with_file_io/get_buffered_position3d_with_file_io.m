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
%Add your customised data acquisition ini file.
data_acquisition_config_file = 'buffered_data';

optotrak_set_up_system(calibration_file, data_acquisition_config_file);

%If you have a peculiar strober set-up, you can specify how many IR LEDs
%are connected to which port of the SCU:

%OptotrakSetStroberPortTable(6, 0, 0, 0); % Port 4 is not available in the Certus system.
pause(1); % need to wait.

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





%% Collect data from the buffer.

[fail, ~] = DataBufferInitializeFile(0, 'buffered_data_10_markers_raw.dat');
if(fail)
    optotrak_tell_me_what_went_wrong;
    error('Couldn''t open file. Have you got permissions?')
end

%You don't need to turn the markers on and off all the time. I just did
%this for neatness.

OptotrakActivateMarkers(); %this turns on the IR LEDs
%Wait, so we have something in the buffer
pause(1);
fprintf('RECORDING NOW....\n')
DataBufferStart; % begin buffering

there_is_data = 0;
spool_complete = 0;
spool_status = 0;
frames_buffered = 0;

% Wait for the acquitision time to go. You can do other things here in your
% code, for example, you can monitor your code real-time

for(i=1:1500)
    [~, framecounter(i), positions(i,:), ~] = DataGetNext3D_as_array();
    
end
fprintf('Stopping buffer and writing data NOW.\n')
optotrak_stop_buffering_and_write_out;




% Note that the buffer is working with RAW data, and this function spools
% it, and then converts it to position3d.

%cd ../../source; %temporarily.



OptotrakDeActivateMarkers(); % turn off the IR LEDs


save('buffered_data_10_markers.mat', 'positions');
fprintf('done.\n')

% %% spool data.
% % This function gets busy for the entire spooling process, but you can
% use it if you want.

% if(DataBufferSpoolData(0))
%     optotrak_tell_me_what_went_wrong;
%     error('DataBufferSpoolData() failed. Check opto.err for details.')
% end
% fprintf('DataBufferSpoolData() complete.\n')

FileClose(0); %close file pointer 0, which is allocated to the raw data file.

%% Convert the recorded raw file to positions

[fail, positions_from_file] = convert_raw_file_to_position3d_array('buffered_data_10_markers_raw.dat');

%% shut down the system
optotrak_kill; 

fprintf('After the execution of the script, ''positions'' and ''positions_from_file'' should have the same data.\n')





