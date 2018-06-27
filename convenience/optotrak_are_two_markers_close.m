function [ markers_are_close ] = optotrak_are_two_markers_close( marker_number_1, marker_number_2, varargin )
%OPTOTRAK_ARE_TWO_MARKERS_CLOSE
% [ markers_are_close ] = optotrak_are_two_markers_close( marker_number_1, marker_number_2, varargin )
% This function tells you whether two markers are close to
%each other.
%   By default, the tolerance is 25mm. You can change this by tossing a third
%   argument, in millimetres.
% Input arguments are:
%   -> marker_number_1 is the NUMBER of the marker in the Optotrak system.
%   -> marker_number_2 is the NUMBER of the marker in the Optotrak system.
%   -> optionally, tolerance, which is a number is millimetres. If not specified, then the distance is set to 25 mm.
% You can specify any marker, and the function will fail if you are out of
% bounds.
% Output argument is:
%   1: if the coordinates are close to each other
%   0: if the coordinates are further away from each other

    % We need to check if a custom tolerance was specified.
    if(nargin == 3)
        tolerance = varargin{1};
    else
        tolerance = 25;
    end
    
    %For fault tolerance, I am not crashing this script. So if the marker is out
    %of bounds or inivisible, this script interprets this as them being far
    %away.

    % Get info for the first marker
    [fail, marker_coords_1] = optotrak_get_marker_coords(marker_number_1);
    if(fail == 1000)
        %if we got here, the marker number was out of bounds.
        markers_are_close = 0;
        return;
    end
    if(fail == -1)
        %If we got here, the marker is invisble
        markers_are_close = 0;
        return;
    end
    
    %Do the same with the second marker
    [fail, marker_coords_2] = optotrak_get_marker_coords(marker_number_2);
    if(fail == 1000)
        %if we got here, the marker number was out of bounds.
        markers_are_close = 0;
        return;
    end
    if(fail == -1)
        %If we got here, the marker is invisble
        markers_are_close = 0;
        return;
    end
    
    %If we didn't fail so far, we can do the actual calculations.
    
    markers_are_close = optotrak_are_two_points_close(marker_coords_1, marker_coords_2, tolerance);
   
    
end

