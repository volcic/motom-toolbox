%Rigid body files can be generated on the fly, but it needs more careful
%thinking. Normally, you won't need to use this, or you'll need it once per
%assembled rigid body.
%Every marker needs a normal vector, which needs to be created. on the fly.
%This script is part of the pen example, and is assumed that everything is
%loaded.


warning_string1 = 'IMPORTANT:\nThis example uses the volciclab universal rigid body.\nIf you have it printed, attach three consecutive markers, and amend the script accordingly.\n';

fprintf(2, warning_string1);
pause(3);

% the volciclab universal rigid body uses 3 markers.
start_marker = 7; %In this case, marker 7

%This is RELATIVE TO THE RIGID BODY.
origin_marker = 3;  %In this case, marker 10 will be set to origin

%First of all, we need to get the positions. Sample about 10 frames, and
%take the average
for(i=1:10)
    [~, ~, positions(i,:), ~] = DataGetNext3D_as_array;
end

position_array = mean(positions, 1);

rigid_body_marker_coords = position_array(start_marker*3+1:(start_marker+3)*3); %These will be the coordinates that the rigid body uses
coordinate_tolerance = 5; % coordinate conversion tolerance.

fprintf(2,'IMPORTANT:\nAlign the rigid body so all markers would point to the Z axis!\n(hint: by default, pointing to the camera, the Z)\nThen continue.\n');

%Generate normal vectors
normal_vectors = repmat([0, 0, 1], 1, 3); %Make sure all markers point at the Z axis!
%normal_vectors = repmat([0, 0, 0], 1, 3); %No normal vectors defined.

optotrak_generate_rigid_body_file(rigid_body_marker_coords, origin_marker, 'volciclab_universal_rigid_body.rig', coordinate_tolerance, normal_vectors);
