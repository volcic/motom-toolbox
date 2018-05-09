function [virtual_marker_coords] = optotrak_get_virtual_marker_coords(virtual_marker_definition, translation, rotation)
%OPTOTRAK_GET_VIRTUAL_MARKER_COORDS
% [virtual_marker_coords] = optotrak_get_virtual_marker_coords(virtual_marker_definition, translation, rotation)
% This is function that calculates the X-Y-Z coordinates of a virtual marker, using the given virtual marker definition and the translation and rotation matrices.
% WARNING: Nothing checks whether the rigid body the virtual marker definition was created with is actually the same as the input of this function.
% This function is designed to get a single virtual marker's coordinates on a rigid body transform that can be many frames. So if you want many virtual markers for the same rigid body, simply execute this funciton with different virtual marker definitions.
% Input arguments are:
%   -> virtual marker definition is a 1-by-6 vector, containing the following:
%       -X-offset, which is the difference between the virtual marker and centroid X coordinates
%       -Y-offset, which is the difference between the virtual marker and centroid Y coordinates
%       -Z-offset, which is the difference between the virtual marker and centroid Z coordinates
%       -roll, wich is the rotation along the X axis in radians of the rigid body at the time of declaration
%       -pitch, wich is the rotation along the X axis in radians of the rigid body at the time of declaration
%       -yaw, wich is the rotation along the X axis in radians of the rigid body at the time of declaration
%   -> translation is the X-Y-Z triplet of the current location of the rigid body
%   -> rotation is the current roll-pitch-yaw orientation of the rigid body, in radians
% virtual_marker_coords contains the calculated virtual marker coordinates, as an X-Y-Z triplet. Each row is a separate frame.

    %Do some sanity checks
    [virtual_marker_frames, virtual_marker_entries] = size(virtual_marker_definition);
    [translation_frames, translation_entries] = size(translation);
    [rotation_frames, rotation_entries] = size(rotation);

    %There can be only one virtual marker definition.
    if(virtual_marker_frames > 1)
        error('This function can only process one virtual marker at a time.')
    end

    %Is it the correct length?
    if(virtual_marker_entries ~= 6)
        error('The virtual marker definition must be a vector, with exactly six entries.')
    end

    %Are we being fed triplets?
    if( (translation_entries ~= 3) || (rotation_entries ~= 3) )
        error('Please execute this funciton on a single rigid body.')
    end

    %Is the rigid body data OK?
    if(translation_frames ~= rotation_frames)
        error('Make sure you use that the translation and rotation arrays have the same number of frames')
    end
    
    %preallocate variables used to store/manipulate data in the loop.
    virtual_marker_coords = zeros(translation_frames, 3);
    %Generate rotation matrices. We will calculate stuff inside here.
    % rotation_matrix_roll = zeros(3, 3);
    % rotation_matrix_pitch = zeros(3, 3);
    % rotation_matrix_yaw = zeros(3, 3);
    % final_rotation_matrix = zeros(3, 3);

    %Okay, now we can work.
    for(i=1:translation_frames)

        %We now can calculate the marker coordinates:
        virtual_marker_coords(i, :) = (virtual_marker_definition(1:3) + translation(i, :));
        %First of all, we need to calculate how much the rigid body rotate since we declared the virtual marker on it.

        relative_rotation = virtual_marker_definition(4:6) - rotation(i, :);
        %This can be simplified, and you can boost performance. A lot.
        %We now build three rotation matrices.

         rotation_matrix_roll = [
             1, 0, 0;
             0, cos(relative_rotation(1)), sin(relative_rotation(1));
             0, -1*sin(relative_rotation(1)), cos(relative_rotation(1));
         ];

         rotation_matrix_pitch = [
             cos(relative_rotation(2)), 0, -1*sin(relative_rotation(2));
             0, 1, 0;
             sin(relative_rotation(2)), 0, cos(relative_rotation(2));
         ];

         rotation_matrix_yaw = [
             cos(relative_rotation(3)), sin(relative_rotation(3)), 0;
             -1*sin(relative_rotation(3)), cos(relative_rotation(3)), 0;
             0, 0, 1;
         ];

        %which we will use to re-calculate the location of the virtual marker
        final_rotation_matrix = rotation_matrix_roll * rotation_matrix_pitch * rotation_matrix_yaw;

        %And now, we rotate the virtual marker coordinates
        % Beware: the coordinates are read out as a column vector, but the function outputs it as a row vector. I could have done this with (matrix_name'), but this way I can see better what's happening.
        rotated_definition_offset = final_rotation_matrix * (virtual_marker_definition(1:3))';

        %And now, we translate the rotated coordinates.
        virtual_marker_coords(i, :) = rotated_definition_offset' + translation(i, :);

    end

end
