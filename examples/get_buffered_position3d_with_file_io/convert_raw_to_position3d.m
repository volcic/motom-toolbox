%As it turned out, it is necessary to initialise the Optotrak system to do
%a successful raw-to-3d conversion.


clear all;
clc;

%% Compensate for not having my own computer.
current_dir = pwd;
cd ../..
add_toolbox_to_path; %this is here because I can't add the toolbox path permanently on this computer.
cd(current_dir);
%TransputerShutdownSystem; %make sure the system is not initialised.

%% Initialise the hardware with the same config file as you ran the experiment with
optotrak_startup(); %note that this takes several seconds to execute.
pause(1); % need to wait.

% If you have a custom camera calibration file, specify it here:
calibration_file = 'standard';
%Add your customised data acquisition ini file.
data_acquisition_config_file = 'buffered_data';

optotrak_set_up_system(calibration_file, data_acquisition_config_file);

%% convert the previously captured data

%You can use this to convert to a position3d file
%FileConvert('raw_data', 'converted_3d_data', 1);

%Or, you can use this:
[fail, positions_from_file] = convert_raw_file_to_position3d_array('buffered_data_10_markers_raw.dat');

%load the previously saved data
load('real_time_data_10_markers.mat')

fprintf('Load and conversion done. ''positions'' should now be the same as ''positions_from_file''\n.')

optotrak_kill;