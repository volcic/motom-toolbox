function [fail] = optotrak_generate_rigid_body_file(coordinates, origin_coordinate, filename, coordinate_tolerance)
%OPTOTRAK_GENERATE_RIGID_BODY_FILE
% [fail] = optotrak_generate_rigid_body_file(coordinates, origin_marker, filename, coordinate_tolerance, normal_vector_coordinates, varargin)
% This function creates a rigid body file, so you can use it with RigidBodyAddFromFile().
% *************************************************
% * IMPORTANT:
% * ONLY USE THIS SCRIPT IF YOU KNOW WHAT YOU ARE DOING!
% * For 99% of the cases, creating a working rigid body is much simpler using NDI's software.
% *************************************************
% NOTE: IF you use this for calibration, please Please PLEASE make sure you use millimetres! The toolbox relies on the metric system.
% The function has two uses:
%   -For calibrating a system, you can specify a marker which will be the origin.
%    This means that the selected marker's coordinates will be [0, 0, 0]. All other coordinates will be translated.
%   -You can also use the coordinates as they come from the system, for instance for creating virtual markers.
% Input arguments are:
%   -> coordinates is a 1-by-N*3 array, containing the X-Y-Z position triplets for each marker.
%
%   -> origin_coordinate is EDIT ME EDIT ME EDIT ME
%
%   -> filename is the path to where the rigid body file will be created.
%       If you want, you can set this to C:\ndigital\rigid\<your_rigid_body>.RIG
%       Make sure you have permission though.
%   -> coordinate_tolerance is the marker position tolerance in millimetres
%       It specifies how much the rigid body conversion error can be before the system decides that it wouldn't return a transformation.
%       Valid range is 0.05...10mm
% Output argument is:
%   -fail, which is zero when everything worked out. There are built-in sanity checks and error messages in this script.



%    %These will be the input arguments
%    coordinates = [-316.65, 78.2079, 131.16546, -98.654, 120.753, 713.123, 100.0001, 434.600, 118.800]; %This is in triplets
%    origin_coordinate = [10, 5, 5]; % This is a single triplet.
%    filename = 'test_rigid_body.rig';
%    coordinate_tolerance = 1; % This is in millimetres!
%    %These will be optional arguments.
    
    %% Internal constants normally nobody should care about
    % This happened because I stripped this script down: I found a better way of using this script.
    
    minimum_visible_markers = 3; % This is kept here as an internal constant.

    %% Argument sanity checks
    
    
    %Input argument sanity check
    if(nargin ~= 4)
        error('This function can''t takes exactly arguments.')
    end
    
    number_of_markers = length(coordinates)/3;


    %Have we got a round number of markers?
    if(mod(number_of_markers, 1))
        error('The supplied coordinates do not make up a round number of markers.')
    end
    
    % Is the origin coordinate a triplet?
    if(length(origin_coordinate) ~= 3)
        error('The origin coordinate must be an X-Y-Z triplet.')
    end
        
    %Can we make the rigid body?
    if(length(coordinates) < 9)
        error('To define a rigid body, you must have at least 3 markers.')
    end

    %% Some coordinate number crunching

    % We need to organise the data into markers.
    for(i=1:number_of_markers)
        markers(i, 1) = coordinates(((i-1)*3) + 1);
        markers(i, 2) = coordinates(((i-1)*3) + 2);
        markers(i, 3) = coordinates(((i-1)*3) + 3);
    end

   
    
    % Translate the coordinates with the specified origin marker
    for(i = 1:3)
        %As I know that there are triplets, I am working in columns.
        rigid_body_coords(:,i) = markers(:,i) - origin_coordinate(i);
    end


    %% Assemble the file!

    file_pointer = fopen(filename, 'w'); %This overwrites the file with the same name
    %I just dump the lines here.
    fprintf(file_pointer, '     Marker Description File\n\nReal 3D\n');
    fprintf(file_pointer, sprintf('%d       ;Number of markers\n1       ;Number of views\n', number_of_markers));
    fprintf(file_pointer, 'Front\nMarker       X       Y       Z       Views\n');

    % Now I need to dump the marker coordinates here
    for(i = 1:number_of_markers)
        fprintf(file_pointer, '%d       %.4f       %.4f       %.4f       1\n', i, rigid_body_coords(i, 1), rigid_body_coords(i, 2), rigid_body_coords(i, 3) );
    end


    %Now that we got these, generate the error criteria. I am using the same
    %number everywhere.
    fprintf(file_pointer, 'MaxSensorError\n%.2f\n\n', coordinate_tolerance);
    fprintf(file_pointer, 'Max3dError\n%.2f\n\n', coordinate_tolerance);
    %The marker visual angle is statically set here.
    fprintf(file_pointer, 'MarkerAngle\n60\n\n');
    fprintf(file_pointer, '3dRmsError\n%.2f\n\n', coordinate_tolerance);
    fprintf(file_pointer, 'SensorRmsError\n%.2f\n\n', coordinate_tolerance);
    fprintf(file_pointer, 'MinimumMarkers\n%d\n\n', minimum_visible_markers);
    
    %Add spread too. This can be also set with tolerance. This is in internal
    %sensor units, which I have no idea of what they are. Also, all my
    %rigid body definitions are initialising this as 0. So let them be 0!
    fprintf(file_pointer, 'MinSpread1\n%.2f\n\n', 0);
    fprintf(file_pointer, 'MinSpread2\n%.2f\n\n', 0);
    fprintf(file_pointer, 'MinSpread3\n%.2f\n\n', 0);
    

    % Once everything is finished, close the file.
    fclose(file_pointer);
end