function [fail, marker_coords] = optotrak_get_marker_coords(marker_number)
%OPTOTRAK_GET_MARKER_COORDS
% [fail, marker_coords] = optotrak_get_marker_coords(marker_number)
% This function returns the coordinates of a single marker.
% Note that this script calls DataGetLatest3D_as_array, to minimise execution time.
%Input arguments are:
%   -> marker_number is the marker that you are querying
%Output arguments are:
% -fail is 0 when the operation was successful.
%  If the marker is not visible, it will be -1.
%  If the marker is outside the detected number of markers, it will be 1000
% marker_coords is a 1-by-3 array, which contains the selected marker coordinates.

    %get data for all the markers in the system. Use *Latest*, to speed up execution time by not having to wait a frame.
    [fail, ~, positions, ~] = DataGetLatest3D_as_array;
    if(length(positions) == 0)
        error('There were no markers detected in the system!')
    end

    %if you want a marker that is outside the range, throw a warning and set the fail value
    if(marker_number > length(positions)/3)
        warning('The selected marker is outside the range of initialised markers.')
        fail = 1000;
        marker_coords = []; %toss back an empty array.

    else
        marker_coords(1) = positions( (marker_number-1)*3+1 );
        marker_coords(2) = positions( (marker_number-1)*3+2 );
        marker_coords(3) = positions( (marker_number-1)*3+3 );
        fail = 0;

        %however, if the marker is invisible, make fail a -1!
        if( isnan(marker_coords(1)) || isnan(marker_coords(2)) || isnan(marker_coords(3)) )
            fail = -1;
            fprintf('Selected marker: %d\n', marker_number);
            warning('Selected marker is invisible.')
            marker_coords = []; %kill data.
        end
    end



end