function [translation_array, rotation_array] = optotrak_calculate_centroid_and_orientation(marker_coordinates, varargin)
%OPTOTRAK_CALCULATE_CENTROID_AND_ORIENTATION This function calculates the centroid of a bunch of markers. The orientation is calculated using a single marker.
% PLEASE NOTE: There is no sanity check on the marker locations. This script works for basic stuff, but if you want to have something fancier, I suggest the use of rigid bodies.
% To avoid confusion and disappointment, use as many markers as possible
% Input arugments are:
%   -> marker_coordinates is an N*3 array, where the X-Y-Z coordinates are stored as triplets
%   -> reference marker is an optional argument. If specified, the orientation will be calculated using a specified marker. Otherwise, the orientation is calculated using the first marker.
% translation_array is an X-Y-Z array of the centroid location. Every row is a different frame.
% rotation_array is the roll-pitch-yaw rotation angle triplet IN RADIANS for each frame.


    %first of all, sanity check.
    if(nargin > 2)
        error('This function can''t handle more than two arguments.')
    end

    %Are we being fed garbage?
    [frames, coordinates] = size(marker_coordinates);
    if(mod(coordinates, 3))
        %incorrect number of cooridnates given.
        fprintf('Length of marker_coordinates array: %d\n', coordinates);
        error('The input must be in X-Y-Z coordinate triplets!')
    else
            number_of_markers = coordinates / 3;
    end

    %Are there enough markers? We need at least 2 markers for centroid calculation
    if(number_of_markers > 2)
        error('There aren''t enough markers to calculate the centroid from!')
    end



    %Process the optional argument.
    if(nargin == 2)
        %If we have a submitted argument...
        reference_marker = varargin{1}; %use the specified marker
        %BUT:
        if(reference_marker > number_of_markers)
            %if we are out of bounds, crash!
            fprintf('number of markers: %d, selected reference marker: %d\n', number_of_markers, reference_marker)
            error('Make sure the reference marker actually exist!')
        end
    else
        % otherwise, use the first marker.
        reference_marker = 1;
    end

    %Do everything for each frame.
    for(i=1:frames)
        %I need to re-orgainse the array. First coordinate is the number of frame, second one is the number of marker, and the third one is the X-Y-Z triplet.
        coordinate_pointer = 1; %reset the pointer for every row
        for(j=1:number_of_markers)
            
            marker_coord_array(i, j, 1) = marker_coordinates(i, coordinate_pointer);
            coordinate_pointer = coordinate_pointer + 1;
            marker_coord_array(i, j, 2) = marker_coordinates(i, coordinate_pointer);
            coordinate_pointer = coordinate_pointer + 1;
            marker_coord_array(i, j, 3) = marker_coordinates(i, coordinate_pointer);
            coordinate_pointer = coordinate_pointer + 1;
        end

        %Once this is done, we can calculate the centroids. Effectively, the centroid is the mean value of the coordinates.
        translation_array(i, 1) = nanmean(marker_coord_array(i, :, 1)); %Ignore NaN values for invisible markers
        translation_array(i, 2) = nanmean(marker_coord_array(i, :, 2)); %Ignore NaN values for invisible markers
        translation_array(i, 3) = nanmean(marker_coord_array(i, :, 3)); %Ignore NaN values for invisible markers

        %Calculate orientation with the selected reference marker. This is fun.
        if( (isnan(marker_coord_array(i, reference_marker, 1))) || (isnan(marker_coord_array(i, reference_marker, 2))) || (isnan(marker_coord_array(i, reference_marker, 3))) )
            %If any of these coordinates are NaN, then the orientation can't be calculated. Shove NaNs everywhere!
            rotation_array(i, 1:3) = NaN;
        else

            %Roll is calculated from the is when the angle is calculated from the Z and Y coordinates
            rotation_array(i, 1) = atan( (marker_coord_array(i, reference_marker, 3) - translation_array(i, 3)) / (marker_coord_array(i, reference_marker, 2) - translation_array(i, 2)) );

            %Pitch is calculated from the is when the angle is calculated from the X and Z coordinates
            rotation_array(i, 2) = atan( (marker_coord_array(i, reference_marker, 1) - translation_array(i, 1)) / (marker_coord_array(i, reference_marker, 3) - translation_array(i, 3)) );
            
            %Yaw is calculated from the is when the angle is calculated from the X and Y coordinates
            rotation_array(i, 3) = atan( (marker_coord_array(i, reference_marker, 1) - translation_array(i, 1)) / (marker_coord_array(i, reference_marker, 2) - translation_array(i, 2)) );


            %Additional safeguard: If any of the rotational coordinates calculated as NaN, make the whole lot NaN.
            if( (isnan(rotation_array(i, 1))) || (isnan(rotation_array(i, 2))) || (isnan(rotation_array(i, 3))) )
                %Make all the rotation angles NaN!
                rotation_array(i, 1:3) = NaN;
            end
        end

    end


end