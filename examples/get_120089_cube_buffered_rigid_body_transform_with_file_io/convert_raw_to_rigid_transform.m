%As it turned out, it is necessary to initialise the Optotrak system to do
%a successful raw-to-rigid body conversion.


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
%Adjust the config file at will. If you do something wrong, it will crash.
data_acquisition_config_file = 'buffer_data_with_120089_cube';
optotrak_set_up_system(calibration_file, data_acquisition_config_file);

% Add rigid body.
if(RigidBodyAddFromFile_euler(0, 1, 'CU-01209')) %If you have more markers, you can offset them here.
    optotrak_tell_me_what_went_wrong;
    error('RigidBodyAddFromFile_euler() failed. Couldn''t add rigid body.')
end


%% temporarily.


cd ../../source

%optotrak_kill