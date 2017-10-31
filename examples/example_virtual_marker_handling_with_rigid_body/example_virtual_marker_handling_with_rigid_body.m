%Very simple virtual marker demo.

%A bit of explanation here.
% First of all, you need to print the rigid body, which has 6 markers.
% The 6_marker_volciclab_rigid_body.rig and stl files are given. The marker
% placements are as follows:
%
% On one side:
%               ___
%              / 3 \
%             /     \
%             \1___5/
%... and the other one:
%               ___
%              / 4 \
%             /     \
%             \2___6/
%
% You can add the chopstick to any hole.
% There are two extra markers, that are on the groung and are placed in the
% universal marker pad. All of them are required.

clear all;
clc;


%camera_file = 'standard'; %Factory settings
camera_file = 'Aligned_2017-10-30_12-31.cam'; %My custom dual-camera settings
config_file = 'example_virtual_marker_handling_with_rigid_body.ini';


%% Initialise the system and load rigid body.

optotrak_startup;
optotrak_set_up_system(camera_file, config_file);
%Now we are ready to go.

[fail] = RigidBodyAddFromFile_euler(0, 1, '6_marker_volciclab_rigid_body');

if(fail)
    optotrak_tell_me_what_went_wrong;
    error('Couldn''t load the specified rigid body. Check opto.err for details')
end

%Load the data collection settings in a structure.
data_acquisition_settings = optotrak_get_setup_info;
%Normally you won't need this, but this is a useful tool to verify whether
%the settings you specified in the config file correctly loads into the system.


%% Sample 50 frames of static marker positions.

fprintf('Get ready to sample 50 frames of marker position data. Do not move anything, and press enter in the command window when ready.\n')
pause;

fprintf('RECORDING NOW.\n')
%This example is hard-coded for marker 7 to be used as a reference.
for(i=1:50)
    [fail, anchor_marker_coords(i, :)] = optotrak_get_marker_coords(7); %Doesn't matter how many duplicates are in these.
end

%Calculate the mean position
virtual_marker_assignment_point = mean(anchor_marker_coords, 1);

%Check whether the marker is visible
if(isnan(virtual_marker_assignment_point))
    error('Marker 7 was not visible. Please try again by re-evaluating this section.')
end

fprintf('Done!\n')
%% Assign virtual marker position.

fprintf('Now place the tip to marker 7, hold it steady, and press enter when ready.\n')
pause;

%We capture a signle frame.

[~, ~, assignment_translation, assignment_rotation, ~] = DataGetNextTransforms2_as_array(0);

%Check whether the rigid body transform was successful. I am taking the
%mean to check whether either coordinate is a NaN.
if(isnan(mean(assignment_translation)))
    error('The rigid body transform was not successful. Check your rigid body by executing DataGetNectTransforms2_as_array(0)')
end

%and now we are ready to assign the optotrak marker.
virtual_marker_definition = optotrak_assign_virtual_marker(virtual_marker_assignment_point, assignment_translation, assignment_rotation);

fprintf('Virtual marker assigned.\n')


%% Capture some rigid body data, and calulate the virtual marker positions.

fprintf('Now we are going to capture 5 seconds'' worth of data. Press enter in the command window when ready.\n')
pause;

fprintf('RECORDING NOW.\n')
for(i=1:(5*data_acquisition_settings.frame_rate_in_fps) )
    [fail, framecounter(i), translation(i, :), rotation(i, :), coordinates(i, :)] = DataGetNextTransforms2_as_array(data_acquisition_settings.number_of_markers);
end

fprintf('Done!\n');

%% Restore virtual marker data, and plot it.

fprintf('Now plotting the virtual marker coordinates.\n')

 %This function can process a signle frame, and a bunch of frames. So you can use it in real-time data.
virtual_marker_coords = optotrak_get_virtual_marker_coords(virtual_marker_definition, translation, rotation);


%This function also can cope with either a single frame of data or many
%frames.
optotrak_plot_marker_positions( virtual_marker_coords );

optotrak_kill;
