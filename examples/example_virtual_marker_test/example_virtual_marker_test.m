% This example creates a simple virtual marker with the cube. You can see three rigid body files here. All of them
% are working with the cube, but:
%   -'ndi_120089_cube.rig' is made so it can be used for alignment: the top of it is the Z=0 plane.
%   -'ndi_120089_cube_centroid_as_origin.rig' is to be used with virutal makers. In this demo, it will be the end
%       of the handle.
%   -'ndi_120089_cube_centroid_as_origin_badly_made.rig' can NOT be used with virtual markers. The reported
%   rotation axes will be inverted and/or swapped.

clear all;
clc;
close all;

% I think it's best if you execute each section with the 'run and advance' feature.


%% Do the alignment first if needed.
%optotrak_align_my_system('example_virtual_marker_test.ini', 'ndi_120089_cube.rig');

%% Initialise the Optotrak system and load the rigid body.

optotrak_startup;
optotrak_set_up_system('standard', 'example_virtual_marker_test.ini');
%optotrak_set_up_system('Aligned_2019-02-13_11-43.cam', 'example_virtual_marker_test.ini');

%% Add rigid body definition

% Use this one to get behaviour as expected.
RigidBodyAddFromFile_euler(0, 1, 'ndi_120089_cube_centroid_as_origin.rig');
% See what happens when you load this rigid body!
%RigidBodyAddFromFile_euler(0, 1, 'ndi_120089_cube_centroid_as_origin.rig');


optotrak_status = optotrak_get_setup_info(); % This one downloads your settings and interprets the flags.

% give the system a nudge
[~, ~, ~, ~, ~] = DataGetNextTransforms2_as_array(optotrak_status.number_of_markers);

%% Virtual marker assignment

% Normally, you could call optotrak_assign_virtual_marker(), but in this case the set-up is so simple, that we can
% do this by hand.

% The virtual marker is pointing upwards, and is appoximately at the end of the handle.
virtual_marker_definition = [0, 0, 200, 0, 0, 0]; % Simple, huh?

%% Capture a frame and display it
% If you want, just run this section again, or perhaps put it in an infinite loop.

% Let's get a frame of data
[fail, framecounter, translation, rotation, markers] = DataGetNextTransforms2_as_array(optotrak_status.number_of_markers);

% Let's calculate the virtual marker coordinate
virtual_marker_coords = optotrak_get_virtual_marker_coords(virtual_marker_definition, translation, rotation);

% Assemble a 'marker cage'. This will make sure the details will not look werid due to scaling.
cage = [translation - [300, 300, 300], translation + [300, 300, 300]];

% Assemble stuff to plot
stuff_to_plot = cat(2, markers, translation, virtual_marker_coords, cage);

% Plot.
optotrak_plot_marker_positions(stuff_to_plot, 'Marker 17 is centroid, 18 is virtual marker, the rest of them is for display.')