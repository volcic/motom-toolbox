function [ ] = optotrak_plot_marker_status( position3d_as_array )
%OPTOTRAK_PLOT_MARKER_STATUS This function generates a plot that indicates
%which marker is visible to the Optotrak system.
% IMPORTANT: It will update the first figure.
% Input arguments are:
%   -> position3d_as_array is a 1-by-(N*3) array, stroing the X-Y-Z triplets
% Returns:
% nothing.


    [no_of_frames, no_of_coords] = size(position3d_as_array);
    %Sanity check: Are we being fed triplets?
    if(mod(no_of_coords, 3))
        fprintf('Received number of coordinates: %d\n', no_of_coords)
        error('Input coordinates must be in triplets.')
    end
    %sanity check: Are we processing a single frame?
    if(no_of_frames > 1)
        error('This function only can display a single frame of data.')
    end
    
   
    

    no_of_markers = no_of_coords / 3;
    % Organise data visualisation pretty much into a square. There will be
    % extra space, but it doesn't matter.

    rows = ceil(sqrt(no_of_markers));
    columns = ceil(no_of_markers/rows);

    marker_info = zeros(rows, columns);

    % internal plotting constants. this ensures correct separation and colours.

    %text_size = 25;
    text_size = 1195*exp(-0.3671*rows) + 15; %I am scaling the fonts with the feature size.

    % Make a matrix that stores visible markers as per position.
    for(i = 1:no_of_markers)
        if( isnan(position3d_as_array((((i-1)*3)+1))) || isnan(position3d_as_array((((i-1)*3)+2))) || isnan(position3d_as_array((((i-1)*3)+3))) )
            %If any of the coordinates are NaN, meaning that the marker is
            %invislble
            marker_info(i) = 0; %address the 2D array sequentially. Makes life easier.
        else
            %if we got here, the marker must be visible.
            marker_info(i) = 1;
        end
    end

    
    figure_handle = figure(1);
    %Add the content!
    set(figure_handle,'Units','normalized');
    set(figure_handle,'Position',[0.125 0.125 0.75 0.75]);
    set(gca, 'FontSize', 36)
    %This is just an indicator, so we can destroy the axes.

    axis off;
    imshow(marker_info', 'InitialMagnification', 'fit', 'Border', 'tight', 'Colormap', prism); %I needed to translate this matrix so it would display properly.
    colormap prism;
    hold on;
    marker_pointer = 1;
    %Add text
    for(i=1:columns)
        for(j=1:rows)
            %Print 'X' when it's a marker that has not been initialised.
            if(marker_pointer > no_of_markers)
                text(j, i, 'X', 'FontSize', text_size, 'HorizontalAlignment', 'center');
            else
                text(j, i, sprintf('%d', marker_pointer), 'FontSize', text_size, 'HorizontalAlignment', 'center');
            end


            marker_pointer = marker_pointer + 1;
        end
    end 
    drawnow;
    
end

