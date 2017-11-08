function [mean_distance_difference] = optotrak_calculate_body_warp( body_position3d_array1, body_position3d_array2 )
%OPTOTRAK_CALCULATE_BODY_WARP
% [mean_distance_difference] = optotrak_calculate_body_warp( body_position3d_array1, body_position3d_array2 )
% This function useful when you use rigid bodies with markers attached to them, but you don't want to use the rigid body functionality of the Optotrak system.
% When the rigid body 'warps', its makers change position with respect to each other. The Optotrak system's rigid body facility takes care of detecting this and fails the rigid body transform, but if you are 'blindly' tracking the centroids, you will have issues with tracking without knowing it.
% This function compares the distances betwenn the markers and the centroid of a body, and will output the maximum difference between the mean value distances for each marker. You can use this function to ckeck whether your tracking is working.
% Input arguments are:
%   -body_position3d_array1, is an f-by(N*3) array, with f frames and N markers
%   -body_position3d_array2, is an f-by(N*3) array, with f frames and N markers
% Returns:
% mean_distance_difference, between the two centroids and markers, in millimetres.


    %% Sanity check
    %First lot: Are we being fed garbage?
    [frames1, coordinates1] = size(body_position3d_array1);
    if(mod(coordinates1, 3))
        %incorrect number of cooridnates given.
        fprintf('Length of the first array: %d\n', coordinates1);
        error('The input must be in X-Y-Z coordinate triplets!')
    else
            number_of_markers1 = coordinates1 / 3;
    end

    %Are there enough markers? We need at least 2 markers for centroid calculation
    if(number_of_markers1 < 2)
        error('First array: There aren''t enough markers to calculate the centroid from!')
    end

    %Second lot: Are we being fed garbage?
    [frames2, coordinates2] = size(body_position3d_array2);
    if(mod(coordinates2, 3))
        %incorrect number of cooridnates given.
        fprintf('Length of the second array: %d\n', coordinates2);
        error('The input must be in X-Y-Z coordinate triplets!')
    else
            number_of_markers2 = coordinates2 / 3;
    end

    %Are there enough markers? We need at least 2 markers for centroid calculation
    if(number_of_markers2 < 2)
        error('Second array: There aren''t enough markers to calculate the centroid from!')
    end


    %The number of markers must be equal.
    if(number_of_markers1 ~= number_of_markers2)
        fprintf('First array: %d makers detected, second array: %d markers detected.\n', number_of_markers1, number_of_markers2);
        error('The two arrays you are calculating the centroids of must have the same number of markers.')
    end

    %% Calculate centroids and calculate the distances from centroids

    %First lot: Do everything for each frame.
    for(i=1:frames1)
        %I need to re-orgainse the array. First coordinate is the number of frame, second one is the number of marker, and the third one is the X-Y-Z triplet.
        coordinate_pointer = 1; %reset the pointer for every row
        for(j=1:number_of_markers1)

            marker_coord1_array(i, j, 1) = body_position3d_array1(i, coordinate_pointer); %X
            coordinate_pointer = coordinate_pointer + 1;
            marker_coord1_array(i, j, 2) = body_position3d_array1(i, coordinate_pointer); %Y
            coordinate_pointer = coordinate_pointer + 1;
            marker_coord1_array(i, j, 3) = body_position3d_array1(i, coordinate_pointer); %Z
            coordinate_pointer = coordinate_pointer + 1;
        end

        %Once this is done, we can calculate the centroids. Effectively, the centroid is the mean value of the coordinates.
        translation1_array(i, 1) = nanmean(marker_coord1_array(i, :, 1)); %Ignore NaN values for invisible markers, X values
        translation1_array(i, 2) = nanmean(marker_coord1_array(i, :, 2)); %Ignore NaN values for invisible markers, Y values
        translation1_array(i, 3) = nanmean(marker_coord1_array(i, :, 3)); %Ignore NaN values for invisible markers, Z values
        
        %Now we calculate the distance of the centroid from each marker.
        % I kept this separate here, for clarity.
        
        for(j=1:number_of_markers1)
            %First dimesntion is the number of frames, the second dimension is
            %the marker number. This is done as:
            % sqrt( (x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2 )
            distances1(i, j) = sqrt( (marker_coord1_array(i, j, 1)-translation1_array(i, 1))^2 + (marker_coord1_array(i, j, 2)-translation1_array(i, 2))^2 + (marker_coord1_array(i, j, 3)-translation1_array(i, 3))^2 );
        end
    end
    distances1_mean = nanmean(distances1, 1); %ignore NaN values, and squish along the frames.

    %Second lot: Do everything for each frame.
    for(i=1:frames2)
        %I need to re-orgainse the array. First coordinate is the number of frame, second one is the number of marker, and the third one is the X-Y-Z triplet.
        coordinate_pointer = 1; %reset the pointer for every row
        for(j=1:number_of_markers2)

            marker_coord2_array(i, j, 1) = body_position3d_array2(i, coordinate_pointer); %X
            coordinate_pointer = coordinate_pointer + 1;
            marker_coord2_array(i, j, 2) = body_position3d_array2(i, coordinate_pointer); %Y
            coordinate_pointer = coordinate_pointer + 1;
            marker_coord2_array(i, j, 3) = body_position3d_array2(i, coordinate_pointer); %Z
            coordinate_pointer = coordinate_pointer + 1;
        end

        %Once this is done, we can calculate the centroids. Effectively, the centroid is the mean value of the coordinates.
        translation2_array(i, 1) = nanmean(marker_coord2_array(i, :, 1)); %Ignore NaN values for invisible markers, X values
        translation2_array(i, 2) = nanmean(marker_coord2_array(i, :, 2)); %Ignore NaN values for invisible markers, Y values
        translation2_array(i, 3) = nanmean(marker_coord2_array(i, :, 3)); %Ignore NaN values for invisible markers, Z values
        
        %Now we calculate the distance of the centroid from each marker.
        % I kept this separate here, for clarity.
        
        for(j=1:number_of_markers2)
            %First dimesntion is the number of frames, the second dimension is
            %the marker number. This is done as:
            % sqrt( (x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2 )
            distances2(i, j) = sqrt( (marker_coord2_array(i, j, 1)-translation2_array(i, 1))^2 + (marker_coord2_array(i, j, 2)-translation2_array(i, 2))^2 + (marker_coord2_array(i, j, 3)-translation2_array(i, 3))^2 );
        end
    end
    distances2_mean = nanmean(distances2, 1); %ignore NaN values, and squish along the frames.


    %Calculate mean distance difference
    mean_distance_difference = distances1_mean - distances2_mean;


    %Return maximum distance difference between means.
    mean_distance_difference = max(abs(mean_distance_difference));
end