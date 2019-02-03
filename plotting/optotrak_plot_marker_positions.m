function [ ] = optotrak_indicate_marker_positions( position3d_as_array, varargin)
%OPTOTRAK_INDICATE_MARKER_POSITIONS This function plots the location of the
%markers it's been fed. If several frames' worth of data is being sent,
%then it will do a line plot for each marker.
% IMPORTANT: It will update the first figure.
% Input arguments are:
%   -> position3d_as_array is an m-by-(N*3) matrix, for N markers and m frames.
%   -> [figure title] is an optional argument, a string for the figure title
% Returns:
% Nothing.

    if(length(varargin) > 1)
        error('This function can only handle one extra optional argument.')
    end
    
    if(length(varargin) == 1 && ischar(varargin{1}))
        %% We got a string as a title, so use it!
        title_string = varargin{1};
    else
        title_string = 'Marker positions';
    end

    [no_of_frames, no_of_coords] = size(position3d_as_array);

    %Sanity check: Are we being fed triplets?
    if(mod(no_of_coords, 3))
        fprintf('Received number of coordinates: %d\n', no_of_coords)
        error('Input coordinates must be in triplets.')
    end

    no_of_markers = no_of_coords / 3;

    legend_strings = cell(1, no_of_markers); %This is for the legend.


    figure_handle = figure(1);
    clf(1);
    %Make figure in the centre of the screen, and reasonably large
    set(figure_handle,'Units','normalized');
    set(figure_handle,'Position',[0.125 0.125 0.75 0.75]);

    %big fonts too.
    set(gca, 'FontSize', 25)
    title(title_string)
    xlabel('X axis [mm]')
    ylabel('Y axis [mm]')
    zlabel('Z axis [mm]')

    %change the view so it will be more 3D-esque
    view(-22.5, 22.5)
    grid on;
    hold on;

    text_offset = 0; % Make the text appear a bit further away of the marker position

    if(no_of_markers > 50)
        warning('Displaying the first 50 markers only.')
        no_of_markers = 50;
    end
    if(no_of_frames == 1)
        %Single frame: scatter3
        for(i=1:no_of_markers)
            x_coordinate = position3d_as_array((i-1)*3 + 1);
            y_coordinate = position3d_as_array((i-1)*3 + 2);
            z_coordinate = position3d_as_array((i-1)*3 + 3);
            scatter3(x_coordinate, y_coordinate, z_coordinate, 2000, 'LineWidth', 6, 'MarkerFaceColor', [0.8, 0.8, 0.8])
            text(x_coordinate + text_offset, y_coordinate + text_offset, z_coordinate + text_offset, sprintf('%d', i), 'FontSize', 25, 'HorizontalAlignment', 'center');
            if( isnan(position3d_as_array((((i-1)*3)+1))) || isnan(position3d_as_array((((i-1)*3)+2))) || isnan(position3d_as_array((((i-1)*3)+3))) )
                %If any of the coordinates are NaN, meaning that the marker is
                %invislble
                legend_strings{i} = sprintf('Marker %d (invisible)', i);
            else
                %if we got here, the marker must be visible.
                legend_strings{i} = sprintf('Marker %d', i);

            end
        end
        legend(legend_strings);
    else
        %Many frames: plot3.
        
        %Also, we need to unify the colours.
        colours = {'red', [0. 0.5, 0], 'black', [0.5, 0.5, 0.5], [0.5, 0.5, 0], [0.5, 0 0.5], 'magenta', [0.5, 0.5, 0], [0, 0, 0.5], 'blue', [0, 0.5, 0.5], [0.5, 0, 0]};
        palette = repmat(colours, 1, 43); %Loop this 'palette' for the worst case scenario.
        for(i=1:no_of_markers)
            x_coordinates = position3d_as_array(:, (i-1)*3 + 1);
            y_coordinates = position3d_as_array(:, (i-1)*3 + 2);
            z_coordinates = position3d_as_array(:, (i-1)*3 + 3);
            plot_handle(i) = plot3(x_coordinates, y_coordinates, z_coordinates, 'LineWidth', 6, 'Color', palette{i}); %Need these plot handles for the 
            %Put the marker indicators at the very ends.
            scatter3(x_coordinates(end), y_coordinates(end), z_coordinates(end), 2000, 'LineWidth', 6, 'MarkerFaceColor', [0.8, 0.8, 0.8], 'MarkerEdgeColor', palette{i})
            text(x_coordinates(end) + text_offset, y_coordinates(end) + text_offset, z_coordinates(end) + text_offset, sprintf('%d', i), 'FontSize', 25, 'HorizontalAlignment', 'center');
            %Genreate legends. Both for the dots and the lines.
            legend_strings{i} = sprintf('Marker %d', i);
            %legend(plot_handle(:), legend_strings);
        end
        legend(plot_handle(:), legend_strings);
    end
    
    drawnow();
end
