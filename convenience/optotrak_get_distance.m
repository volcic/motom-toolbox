function [ distance ] = optotrak_get_distance( coord_triplet_1, coord_triplet_2 )
%OPTOTRAK_GET_DISTANCE This function calculates the distance between two x-y-z
%coordinates.
% Input arguments are:
%   -> coord_triplet_1 is the X-Y-Z coordinate triplet of the fist point
%   -> coord_triplet_2 is the X-Y-Z coordunate triplet of the second
% Output arguments are:
% -distance is the distance between the two points.

    if( (length(coord_triplet_1) ~= 3) || (length(coord_triplet_2) ~= 3) )
        error('This function only works with X-Y-Z coordinate triplets.')
    end

    distance = sqrt( ((coord_triplet_1(1) - coord_triplet_2(1))^2) +  ((coord_triplet_1(2) - coord_triplet_2(2))^2) + ((coord_triplet_1(3) - coord_triplet_2(3))^2) );
    


end

