function [virtual_marker_definition] = optotrak_assign_virtual_marker(virtual_marker_coords, centroid_coordinates, rotation)
%OPTOTRAK_ASSIGN_VIRTUAL_MARKER
% [virtual_marker_definition] = optotrak_assign_virtual_marker(virtual_marker_coords, centroid_coordinates, rotation)
% This function generates the association parameters of a given virtual marker and a known rigid body.
% Ideally, only a single set of coordinates are required. You can use the output of this function to determine where the virtual marker is once the rigid body has moved away.
% WARNING: If you calculate the centroid and orientation without defining a rigid body in the system, it's your responsibility to make sure that the markers you used in the calculation are at a fixed distance from each other.
% Input parameters are:
%   -> virtual_marker_coords is an X-Y-Z triplet, and is the known location of the virtual marker you want to assign to
%   -> centroid_coordinates is an X-Y-Z triplet which contains the location of the rigid body
%   -> rotation is the roll-pitch-yaw triplet that determines the orientation of the rigid body.
% virtual marker definition is a vector, which contains the following:
%   x_offset, which is the coordinate difference between the centroid and the virtual marker coordinates
%   y_offset, which is the coordinate difference between the centroid and the virtual marker coordinates
%   z_offset, which is the coordinate difference between the centroid and the virtual marker coordinates
%   roll, which is the rotation along the X axis in radians of the rigid body at the time of declaration
%   pitch, which is the rotation along the X axis in radians of the rigid body at the time of declaration
%   yaw, which is the rotation along the X axis in radians of the rigid body at the time of declaration

    %First of all, do some sanity checks on the input parameters.
    [virtual_marker_frames, virtual_marker_triplet_length] = size(virtual_marker_coords);
    [centroid_frames, centroid_triplet_length] = size(centroid_coordinates);
    [rotation_frames, rotation_triplet_length] = size(rotation);

    %Are we to process many frames at the same time?
    if( (virtual_marker_frames < 1) ||(centroid_frames < 1) || (rotation_frames < 1) )
        error('Are you sure you want to assign a virtual marker for every frame of data?')
    end
    %Are we being fed garbage?
    if( (virtual_marker_triplet_length ~= 3) || (centroid_triplet_length ~= 3) || (rotation_triplet_length ~= 3) )
        error('Make sure all input parameters are triplets.')
    end

    %Does the rigid body data look OK?
    if(centroid_frames ~= rotation_frames)
        error('The tranlation and rotation matrices must have the same number of rows.')
    end

    %You shouldn't need to boost performance here, as you don't want to assign virtual markers every time.
    virtual_marker_definition(1) = virtual_marker_coords(1) - centroid_coordinates(1); %X offset
    virtual_marker_definition(2) = virtual_marker_coords(2) - centroid_coordinates(2); %Y offset
    virtual_marker_definition(3) = virtual_marker_coords(3) - centroid_coordinates(3); %Z offset

    %Save the orientation at declaration time as well, as I need it to restore the position.
    virtual_marker_definition(4) = rotation(1); %roll
    virtual_marker_definition(5) = rotation(2); %pitch
    virtual_marker_definition(6) = rotation(3); %yaw




end