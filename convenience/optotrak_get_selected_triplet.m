function [ selected_triplet ] = optotrak_get_selected_triplet( triplet_number, data_array )
%OPTOTRAK_GET_SELECTED_TRIPLET This functions gets a triplet out from the array.
% [ selected_triplet ] = optotrak_get_selected_triplet( triplet_number, data_array)
% This is ideal for selecting the appropriate data for a single marker, or
% rigid body transforms
% Input arguments are:
%   -> triplet_number is the appropriate triplet in the marker array.
%       for example:
%           3 returns entries 7, 8, and 9
%           [1, 3] returns the concatenation of 1, 2, 3 and 7, 8, 9
%   -> data_array is the array the appropriate triplets are selected from.
% Returns:
% The selected triplet. If multiple tripets are selected, the triplets are
% concatenated.
%
% NOTE: this function works on matrices too.

    %first of all, check in the inputs makes sense.
    [frames, entries] = size(data_array);
    [triplet_height, triplet_width] = size(triplet_number);
    
    %Check whether the data is correct
    if(mod(entries, 3))
        error('The data array the triplet is selected from must be N*3 in width!')
    end
    if( (triplet_height > 1) && (triplet_width > 1) )
        error('The triplet numbers must be a single row or single_column vector')
    end
    
    if( (triplet_width > 1) || (triplet_height > 1) )
        %Check whether the largest triplet number is within bounds
        if(max(triplet_number) > entries/3)
            error('A triplet given is outside the data array!')
        end
        
        %Okay, now we are in business.
        no_of_triplets = length(triplet_number);
        %Create the output array
        selected_triplet = zeros(frames, no_of_triplets*3);
        
        for(i=1:no_of_triplets)
            %Go through the triplets, and then concatenate.
            selected_triplet(:, (i-1)*3+1) = data_array(:, (triplet_number(i)-1)*3+1 );
            selected_triplet(:, (i-1)*3+2) = data_array(:, (triplet_number(i)-1)*3+2 );
            selected_triplet(:, (i-1)*3+3) = data_array(:, (triplet_number(i)-1)*3+3 );
        end
    
    else

        if(triplet_number > entries/3)
            %if we got here, there is an addressing overflow.
            error('The selected triplet is outside the data array!')
        else
            %Do the calculation
            selected_triplet(:, 1) = data_array(:, (triplet_number-1)*3+1 );
            selected_triplet(:, 2) = data_array(:, (triplet_number-1)*3+2 );
            selected_triplet(:, 3) = data_array(:, (triplet_number-1)*3+3 );
        end
    end

end

