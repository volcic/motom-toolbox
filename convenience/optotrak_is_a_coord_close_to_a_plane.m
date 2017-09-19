function [ proximity_alert ] = optotrak_is_a_coord_close_to_a_plane( coord_triplet, plane, varargin )
%OPTOTRAK_IS_A_COORD_CLOSE_TO_A_PLANE This function returns 1 if a
%coordinate is close to a selected plane, and 0 if it isn't.
% Input arguments are:
%   -> coord_triplet is a 1-by-3 array, with the X-Y-Z coordinates 
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

