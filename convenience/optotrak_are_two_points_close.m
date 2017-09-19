function [ proximity_alert ] = optotrak_are_two_points_close( coord_triplet_1, coord_triplet_2, varargin )
%OPTOTRAK_ARE_TWO_POINTS_CLOSE This function tells you whether two points are close in a form of a boolean.
%   By default, the tolerance is 25mm. You can change this by tossing a third
%   argument, in millimetres.
% Input arguments are:
%   -> coord_triplet_1 is the X-Y-Z coordinate triplet of the first point
%   -> coord_triplet_2 is the X-Y-Z coordinate triplet of the second point
%   -> optionally, tolerance which is in millimetres
% Output argument is:
%   1: if the coordinates are close to each other
%   0: if the coordinates are further away from each other

    %Check the number of arguments
    if(nargin == 3)
        tolerance = varargin{1};
    else
        tolerance = 25; %Assing this default value
    end

    % call my internal function
    distance = optotrak_get_distance( coord_triplet_1, coord_triplet_2 );
    
    if(distance < tolerance)
        proximity_alert = 1;
    else
        proximity_alert = 0;
    end

end

