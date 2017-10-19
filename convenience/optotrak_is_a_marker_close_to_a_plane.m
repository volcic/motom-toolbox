function [ proximity_alert ] = optotrak_is_a_marker_close_to_a_plane( marker_number, plane, varargin )
%OPTOTRAK_IS_A_MARKER_CLOSE_TO_A_PLANE
% [ proximity_alert ] = optotrak_is_a_marker_close_to_a_plane( marker_number, plane, varargin )
% This function tells whether a
%properly initialised Optotrak marker is close to a plane or not. 
% Input arguments are:
%   -> marker_number is the marker in the Optotrak system.
%   -> plane is the X, Y, or Z plane you want to test for.
%      Give this arguments as a string, i.e. 'X', or 'z'
%   -> threshold is the distance in millimetres. If not specified, it
%      defaults to 5 mm.


    %Check the number of arguments
    if(nargin == 3)
        threshold = varargin{1};
    else
        threshold = 5;
    end


    proximity_alert = 0; % if nothing touches this variable, that means that they are not close.
    
    %Fetch marker coordinates.
    [fail, coord_triplet] = optotrak_get_marker_coords(marker_number);
    
    if(fail)
        warning('Couldn''t get marker coordinates.')
    end
    
    % Check the planes selected, for the relevant coordinate.
    if(plane == 'X' || plane == 'x')
        if( abs(coord_triplet(1)) <= threshold )
            proximity_alert = 1;
            return;
        end
    elseif(plane == 'Y' || plane == 'y')
        if( abs(coord_triplet(2)) <= threshold )
            proximity_alert = 1;
            return;
        end
    elseif(plane == 'Z' || plane == 'z')
        if( abs(coord_triplet(3)) <= threshold )
            proximity_alert = 1;
            return;
        end
    else
        error('Invalid plane selected for proximity check. Valid values are ''X'', ''Y'', or ''Z''.')
    end
    
end

