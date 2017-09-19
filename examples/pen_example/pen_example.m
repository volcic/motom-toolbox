% This script defines a rigid body, which is used to assign a virtual
% marker. The virtual marker is used as a pen, so you can write on the
% table and see the output on the screen.

clear all;
clc;

optotrak_startup;

%% Compensate for not having my own computer.
current_dir = pwd;
cd ../..
add_toolbox_to_path; %this is here because I can't add the toolbox path permanently on this computer.
cd(current_dir);
%optotrak_kill; %make sure the system is not initialised.
%% Initialise the hardware.
optotrak_startup(); %note that this takes several seconds to execute.

% If you have a custom camera calibration file, specify it here:
calibration_file = 'standard';
%Adjust the config file at will. If you do something wrong, it will crash.
data_acquisition_config_file = 'pen_example_real_time_data';
optotrak_set_up_system(calibration_file, data_acquisition_config_file);


OptotrakActivateMarkers();


%% Load rigid body

%start_maker is the first marker of the rigid body
start_marker = 7;
rigid_body_id = 0; %Always start from 0.
fail = RigidBodyAddFromFile_euler(0, start_marker, 'volciclab_universal_rigid_body.rig');




