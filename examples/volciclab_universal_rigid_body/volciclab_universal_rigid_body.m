%This script creates the rigid body definition to the volciclab universal
%rigid body. The 3D-printable stl file is included here.
%It uses 3 markers in a triangle shape.

clear all;
clc;

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
%calibration_file = 'Aligned20170425';
%Adjust the config file at will. If you do something wrong, it will crash.
data_acquisition_config_file = 'rigid_body_creator_environment';
optotrak_set_up_system(calibration_file, data_acquisition_config_file);

OptotrakActivateMarkers();

%% Get point coordinates for the rigid body

%Get marker coordinates and calculate normal vectors
% the volciclab universal rigid body uses 3 markers.
start_marker = 7; %In this case, marker 7
number_of_markers_in_the_rigid_body = 3; %Make sure you don't exceed the total number of markers currently used.
origin_marker = 0; %not used, because we are not calibrating...
coordinate_tolerance = 1; % in mm


%This is here for a sanity check, because I like plugging numbers in...
if(number_of_markers_in_the_rigid_body > 3)
    error('If you have more than 3 points, you can''t define a single plane.')
end


%First of all, we need to get the positions. Sample about 50 frames, and
%take the average
for(i=1:50)
    [~, ~, positions(i,:), ~] = DataGetNext3D_as_array;
end

position_array = nanmean(positions, 1); %ignore invisible markers, if/when possible.

rigid_body_coordinates = position_array( ((start_marker*3) + 1) :((start_marker*3) + (number_of_markers_in_the_rigid_body*3)) ); %These will be the coordinates that the rigid body uses

%% Prepare the coordinates and normal vectors.

%Disassemble the coordinates.
for(i=1:number_of_markers_in_the_rigid_body)
    individual_coordinates(i,:) = rigid_body_coordinates(((i-1)*3+1):((i-1)*3+3));
end

%Translate these coordinates to the first marker. This will be the local
%origin.
for(i=1:number_of_markers_in_the_rigid_body)
    translated_coordinates(i, :) = individual_coordinates(i,:) - individual_coordinates(1, :);
end

%Re_assemble it to a nice 1-by-N vector.
array_pointer = 1;
for(i=1:3)
    for(j=1:3)
        rigid_body_translated_coordinates(array_pointer) = translated_coordinates(i, j);
        array_pointer = array_pointer + 1;
    end
end


%Create the normal vectors for each points
% This is hard-coded.

%Create the vectors to get to a neighbouring point
vectors.ab = individual_coordinates(1, :) - individual_coordinates(2, :);
vectors.ac = individual_coordinates(1, :) - individual_coordinates(3, :);
vectors.bc = individual_coordinates(2, :) - individual_coordinates(3, :);

%Calculate the normal vectors for each of these points. They have to point
%TOWARDS the camera!
normals(1, :) = -1 * cross(vectors.ab, vectors.ac, 2); %for point A
normals(2, :) = -1 * cross(vectors.ab, vectors.bc, 2); %for point B
normals(3, :) = -1 * cross(vectors.ac, vectors.bc, 2); %for point C

%assemble it to an 1-by-N vector, so the function can eat it.
array_pointer = 1;
for(i=1:3)
    for(j=1:3)
        normal_vector_array(array_pointer) = normals(i, j);
        array_pointer = array_pointer + 1;
    end
end


%% Call the rigid body generator function
optotrak_generate_rigid_body_file(rigid_body_translated_coordinates, origin_marker, 'volciclab_universal_rigid_body.rig', coordinate_tolerance, normal_vector_array);



%% Add the rigid body definition to the system
[fail] = RigidBodyAddFromFile_euler(0, start_marker, 'volciclab_universal_rigid_body.rig');
%[fail] = RigidBodyAddFromFile_euler(0, start_marker, 'triangle_built.rig');
%[fail] = RigidBodyAddFromFile_euler(0, start_marker, 'CU-01209.rig');
if(fail)
    error('Adding rigid body failed.');
end

% delay.
pause(3);


%% Execute the rigid body transform

fprintf('Collecting a few frames, please stand by...\n')
%Are the coordinates visible?

%[~, ~, test_positions, ~] = DataGetNext3D_as_array

for(i=1:10)
    [~, ~, translation(i,:), rotation(i,:), test_positions(i,:), ~] = DataGetNextTransforms2_as_array(0);
end

% fprintf('Done, killing system. Enjoy.\n')
% optotrak_kill;