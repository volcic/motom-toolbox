% Example rigid body handling.

%For the sake of simplicity, we will use the NDI cube for this, and using
%real-time data.


clear all;
clc;


%% Alignemnt.

%If you haven't already done so, please align your coordinate system, by
%executing this line below.
%optotrak_align_my_system('this_works_with_the_ndi_cube.ini', 'ndi_cube.rig');


%% Initialisation

config_file = 'example_rigid_body_handling.ini';
camera_file = 'standard'; %if you want, you can use the default coordinate system.




optotrak_startup;
optotrak_set_up_system(camera_file, config_file);

%Now the system is initialised, and is ready to go.


%% Load rigid body into the system

fail = RigidBodyAddFromFile_euler(0, 1, 'ndi_cube.rig'); %Rigid body ID 0, the rigid body starts from marker 1, and the specified rigid body file is used in the definition. Euler angles (roll, pitch, yaw) are used.

%This is for error managemeent
if(fail)
    optotrak_tell_me_what_went_wrong
    error('Couldn''t load the rigid body.')
end

% Check our system
setup_info = optotrak_get_setup_info;

if(setup_info.number_of_loaded_rigid_bodies)
    %If there is a rigid body loaded in the system, we will get here.
    fprintf('Number of loaded rigid bodies: %d.\n', setup_info.number_of_loaded_rigid_bodies); %just for show.
end

%% Capture 100 frames of rigid body transforms
fprintf('RECORDING NOW.\n')
for(i=1:100)
    [fail, framecounter(i), translation(i, :), rotation(i, :), position3d_array(i,:)] = DataGetNextTransforms2_as_array(setup_info.number_of_markers); %If you get the input argument as 0, you won't get the marker positions.
end

fprintf('Done.\n')


%% Plot the translations.

fprintf('Plotting the rigid body translations.\n')
optotrak_plot_marker_positions(translation);


optotrak_kill;

