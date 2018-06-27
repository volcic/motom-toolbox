% How to create rigid bodies: an example
% In order to use the script, you need to have the Optotrak system working,
% and have the markers attached to the object to which you want to create
% the rigid body definiton of. 


clear all;
close all;
clc;


%% Alignment. Only execute if needed.
alignment_config_file = 'this_works_with_the_ndi_cube.ini';
alignment_rigid_body_file = 'ndi_cube.rig';


%optotrak_align_my_system(alignment_config_file', alignment_rigid_body_file);


%% Init.
% Make sure that all markers are on the rigid body, and the strober is
% plugged in to port 1. Do not leave extra markers lying about.

camera_file = 'standard'; %Change this to your camera file
config_file = 'config_file.ini';
error('Edit ''config_file.ini'' to tailor it to your needs and then comment this error message out.')

optotrak_startup;
optotrak_set_up_system(camera_file, config_file);

fprintf('While recording, make sure that all the markers are visible.\nIf not all markers are visible, you will need to repeat the recording.\nAlso make sure that the body doesn''t move while recording.\n\nPress Enter in the command window to confirm and begin recording.\n')
fprintf('(GREEN = marker visible, ')
fprintf(2, 'RED ')
fprintf('= marker not visible)\n')
pause();

%% Record marker positions of static rigid body.

%Make a raw data file.
DataBufferInitializeFile(0, 'position_recording.dat'); % 0 means Optotrak.


DataBufferStart;
fprintf('Now recording.\n');

spool_complete = 0;
real_time_data_available = 0;
spool_status = 0;
frames_buffered = 0;

while(~spool_complete)
    [~, ~, real_time_position3d_array, ~] = DataGetLatest3D_as_array; %This fetches real-time data
    optotrak_plot_marker_status(real_time_position3d_array); %This shows which markers are visible
    
    %And this statement 'spools' the buffer content to the hard drive 
    [fail, real_time_data_available, spool_complete, spool_status, frames_buffered ] = DataBufferWriteData(real_time_data_available, spool_complete, spool_status, frames_buffered);
    fprintf('Frames buffered: %d\n', frames_buffered)
end

fprintf('Data file recorded.\n');

OptotrakDeActivateMarkers; %This makes sure that the markers are off so they won't overheat.
close all;

[~, buffered_position3d_array] = optotrak_convert_raw_file_to_position3d_array('position_recording.dat'); %this converts the raw data files to position.
optotrak_kill; %Stop the Optotrak system.
fprintf('Press Enter in the command window to show recorded marker positions. Check if the markers actually stayed steady.\nIf not, repeat the recording.\n')
pause();

%% Display recording.

optotrak_plot_marker_positions(buffered_position3d_array);

%% The choice.
fprintf('You can create the rigid body file two ways:\n1., Take the exported CSV file, and load it into NDI''s 6D Architect for sohisticated applications.\n')
fprintf('2., Use the internal functions to create a rigid body file. This is more convenient, but may not always work.\n')


%% Export data to csv.
%Export the buffered data to a .csv file, so it can be read in by other applications
csvwrite('recorded_marker_coordinates.csv', buffered_position3d_array);

%% Create rigid body file internally.

%Calculate mean marker coordinate values
mean_coordinate_values = nanmean(buffered_position3d_array, 1);

origin_marker = 1; %this will have the coordinates of [0, 0, 0] for the given marker, and all other coordinates will be translated accordingly.
tracking_tolerance = 2; %This is in millimetres
normal_vectors = zeros(1, length(mean_coordinate_values)); %Forget about the normal vectors.
minimum_visible_markers = 3; %This is the absolute minimum. Increase this to enforce stricter transforms.

optotrak_generate_rigid_body_file(mean_coordinate_values, origin_marker, 'internally_generated_rigid_body_file.rig', tracking_tolerance, normal_vectors, minimum_visible_markers);

fprintf('Done.\n''recorded_marker_coordinates.csv'' contains the marker coordinates\n''internally_generated_rigid_body_file.rig'' contains the rigid body definition.\nTest it before using it!\n')
