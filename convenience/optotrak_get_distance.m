function [ distances ] = optotrak_get_distance( coord_triplet_1, coord_triplet_2 )
%OPTOTRAK_GET_DISTANCE
% [ distance ] = optotrak_get_distance( coord_triplet_1, coord_triplet_2 )
% This function calculates the distance between two x-y-z
% coordinates. Dimension 1 is the number of frames, and dimension 2 is X-Y-Z.
% Input arguments are:
%   -> coord_triplet_1 is the X-Y-Z coordinate triplet of the fist point
%   -> coord_triplet_2 is the X-Y-Z coordunate triplet of the second
% Output arguments are:
% -distance is the distance between the two points.

    [coord_triplet_1_frames, coord_triplet_1_length] = size(coord_triplet_1);
    [coord_triplet_2_frames, coord_triplet_2_length] = size(coord_triplet_2);

    if( (coord_triplet_1_length ~= 3) || (coord_triplet_2_length ~= 3) )
        error('This function only works with X-Y-Z coordinate triplets.')
    end
    
    if(coord_triplet_1_frames ~= coord_triplet_2_frames)
        error('Make sure you are using the same number of frames for the distance calcukation!')
    end

    % Effectively, this one does:
    % distance = sqrt( (x1-x2)^2 + (y1-y2)^2 + (z1-z2^2))
    % ...and for the previous version of this function, it was:
    % distance = sqrt( ((coord_triplet_1(1) - coord_triplet_2(1))^2) +  ((coord_triplet_1(2) - coord_triplet_2(2))^2) + ((coord_triplet_1(3) - coord_triplet_2(3))^2) );
    
    x_coordinate_differences(:) = coord_triplet_1(:, 1) - coord_triplet_2(:, 1);
    y_coordinate_differences(:) = coord_triplet_1(:, 2) - coord_triplet_2(:, 2);
    z_coordinate_differences(:) = coord_triplet_1(:, 3) - coord_triplet_2(:, 3);
    
    distances(:) = sqrt( (x_coordinate_differences.^2) + (y_coordinate_differences.^2) + (z_coordinate_differences.^2));
    


end

