function [centroid_marker_differences] = optotrak_calculate_centroid_marker_distance(position3d_array)
%OPTOTRAK_CALCULATE_CENTROID_MARKER_DISTANCE
% [centroid_marker_differences] = optotrak_calculate_centroid_marker_distance(position3d_array)
% This function calculated the centroid of a bunch of markers, and returns the distances between the centroid and each marker.
% You can give this function multiple frames of data.
%Input arguments are:
%   -> position3d_array, which is a f-by-(N*3) array, for f frames and N markers.
%Returns:
% centroid_marker_differences, which is an f-by-N array, for f frames and N markers.


    %% Sanity check.
    %Are we being fed garbage?
    [frames, coordinates] = size(position3d_array);
    if(mod(coordinates, 3))
        %incorrect number of cooridnates given.
        fprintf('Length of the first array: %d\n', coordinates);
        error('The input must be in X-Y-Z coordinate triplets!')
    else
            number_of_markers = coordinates / 3;
    end

    %Are there enough markers? We need at least 2 markers for centroid calculation
    if(number_of_markers < 2)
        error('First array: There aren''t enough markers to calculate the centroid from!')
    end

    %% Do everything for each frame.
    for(i=1:frames)
        %I need to re-orgainse the array. First coordinate is the number of frame, second one is the number of marker, and the third one is the X-Y-Z triplet.
        coordinate_pointer = 1; %reset the pointer for every row
        for(j=1:number_of_markers)

            marker_coord_array(i, j, 1) = position3d_array(i, coordinate_pointer); %X
            coordinate_pointer = coordinate_pointer + 1;
            marker_coord_array(i, j, 2) = position3d_array(i, coordinate_pointer); %Y
            coordinate_pointer = coordinate_pointer + 1;
            marker_coord_array(i, j, 3) = position3d_array(i, coordinate_pointer); %Z
            coordinate_pointer = coordinate_pointer + 1;
        end

        %Once this is done, we can calculate the centroids. Effectively, the centroid is the mean value of the coordinates.
        translation_array(i, 1) = nanmean(marker_coord_array(i, :, 1)); %Ignore NaN values for invisible markers, X values
        translation_array(i, 2) = nanmean(marker_coord_array(i, :, 2)); %Ignore NaN values for invisible markers, Y values
        translation_array(i, 3) = nanmean(marker_coord_array(i, :, 3)); %Ignore NaN values for invisible markers, Z values
        
        %Now we calculate the distance of the centroid from each marker.
        % I kept this separate here, for clarity.
        
        for(j=1:number_of_markers)
            %First dimesntion is the number of frames, the second dimension is
            %the marker number. This is done as:
            % sqrt( (x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2 )
            centroid_marker_differences(i, j) = sqrt( (marker_coord_array(i, j, 1)-translation_array(i, 1))^2 + (marker_coord_array(i, j, 2)-translation_array(i, 2))^2 + (marker_coord_array(i, j, 3)-translation_array(i, 3))^2 );
        end
    end
