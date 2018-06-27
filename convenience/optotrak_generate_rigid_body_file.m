function [fail] = optotrak_generate_rigid_body_file(coordinates, origin_marker, filename, coordinate_tolerance, normal_vector_coordinates, varargin)
%OPTOTRAK_GENERATE_RIGID_BODY_FILE
% [fail] = optotrak_generate_rigid_body_file(coordinates, origin_marker, filename, coordinate_tolerance, normal_vector_coordinates, varargin)
% This function creates a rigid body file, so you can use it with RigidBodyAddFromFile().
% NOTE: IF you use this for calibration, please Please PLEASE make sure you use millimetres! The toolbox relies on the metric system.
% The function has two uses:
%   -For calibrating a system, you can specify a marker which will be the origin.
%    This means that the selected marker's coordinates will be [0, 0, 0]. All other coordinates will be translated.
%   -You can also use the coordinates as they come from the system, for instance for creating virtual markers.
% Input arguments are:
%   -> coordinates is a 1-by-N*3 array, containing the X-Y-Z position triplets for each marker.
%   -> origin_marker is the marker to be used as the origin. This is good for calibration
%       Set this to the appropriate number of marker to use that marker as origin. The manual calls this a 'local' coordinate system
%       If you don't want this feature, set it to 0, and the rigid body will be in the 'default' coordinate system.
%   -> filename is the path to where the rigid body file will be created.
%       If you want, you can set this to C:\ndigital\rigid\<your_rigid_body>.RIG
%       Make sure you have permission though.
%   -> coordinate_tolerance is the marker position tolerance in millimetres
%       It specifies how much the rigid body conversion error can be before the system decides that it wouldn't return a transformation.
%       Valid range is 0.05...10mm
%   -> normal_vector_coordinates is a 1-by-N array. The normal vectors are perpendicular to the marker's plane.
%       If unsure, just give it a bunch of zeros.
%       For simple rigid bodies, all normal vectors can point to the same direction
%       Also, since this is a normal vector the length of the vector must be 1.
% Optional input argument is:
%   -> minimum_visible_markers is a number that tells the Optotrak system to give up transforming rigid bodies 
% Output argument is:
%   -fail, which is zero when everything worked out. There are built-in sanity checks and error messages in this script.



%    %These will be the input arguments
%    coordinates = [-316.65, 78.2079, 131.16546, -98.654, 120.753, 713.123, 100.0001, 434.600, 118.800]; %This is in triplets
%    origin_marker = 2;
%    filename = 'test_rigid_body.rig';
%    coordinate_tolerance = 1; % This is in millimetres!
%    normal_vector_coordinates = [0, 0, 1, 0, 0, 1, 0, 0, 1];
%    %These will be optional arguments.
%    minimum_visible_markers = 3; % You will need to change this in your design. 

    %Input argument sanity check
    if(nargin > 6)
        error('This function can''t take more than 5 arguments.')
    end

    %% Argument sanity checks
    number_of_markers = length(coordinates)/3;
    number_of_normals = length(normal_vector_coordinates)/3;

    %sanity check on the minimum number of markers
    if(nargin == 6)
        minimum_visible_markers = varargin{1};
        if(minimum_visible_markers < 3)
            error('You must have at least 3 markers visible for a successful rigid body transform!')
        end
    else
        %As a rule of thumb, you'll need 3 markers to be visible at all times to make a rigid body.
        %However, this depends on the definition of the rigid body.
        minimum_visible_markers = 3;
    end
    %Also, warn the user
    if(minimum_visible_markers ~= number_of_markers)
        warning('The minimum amount of visible markers are less than how many markers you have. While this is not an immediate problem, too loose constraints can cause erroneous transforms.')
    end


    %Have we got a round number of markers?
    if(mod(number_of_markers, 1))
        error('The supplied coordinates do not make up a round number of markers.')
    end
    %Have we got enough normal vectors to be assigned for each marker?
    if(mod(number_of_normals, 1))
        error('Marker normal vector coordinates must be in X-Y-Z triplets.')
    end
    
%     %Are the normal vectors specified as normal coordinates?
%     if(min(normal_vector_coordinates) < -1 || max(normal_vector_coordinates) > 1)
%         %I can't be bothered to check normal vector lengths.
%         error('Normal vector coordinates must be between -1 and 1.')
%     end
    
    if(number_of_normals ~= number_of_markers)
        error('If you specify normal vectors, make sure you specify it for all markers.')
    end


    %Can we make the rigid body?
    if(length(coordinates) < 9)
        error('To define a rigid body, you must have at least 3 markers.')
    end

    %Do we need to set the origin?
    if(origin_marker < 1 || origin_marker > (length(coordinates)/3) )
        %If we got here, the marker that is selected to be the origin doesn't exist.
        % I interpret this as no need to translate coordinates.
        origin_marker = 0;
    end

    %% Some coordinate number crunching

    % We need to organise the data into markers.
    for(i=1:number_of_markers)
        markers(i, 1) = coordinates(((i-1)*3) + 1);
        markers(i, 2) = coordinates(((i-1)*3) + 2);
        markers(i, 3) = coordinates(((i-1)*3) + 3);
    end

    % Also, do the same with the normal vectors
    for(i=1:number_of_normals)
        normals(i, 1) = normal_vector_coordinates(((i-1)*3) + 1);
        normals(i, 2) = normal_vector_coordinates(((i-1)*3) + 2);
        normals(i, 3) = normal_vector_coordinates(((i-1)*3) + 3);
    end

    % If the normal vectors are not given, they shoudl all be zeros.
    if(max(abs(normals)) == 0)
        %if we got here, the normal vectors are all zeros.
        add_normal_vectors = 0; %Do not include normal vectors in the rigid body file.
    else
        add_normal_vectors = 1; %Add the normal vectors in the rigid body file.
    end

    if(origin_marker)
        %Need to select which marker is the origin. This coordinate will be [0, 0, 0], and all the other coordinates will be translated accordingly.
        origin_marker_coords = markers(origin_marker, :);
        %And now calculate the new coordinates.
        for(i = 1:3)
            %As I know that there are triplets, I am working in columns.
            rigid_body_coords(:,i) = markers(:,i) - origin_marker_coords(i);
        end
    else
        %No need to translate, just toss things as they are.
        rigid_body_coords = markers;
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

    if(add_normal_vectors)
        % When the normal vectors are not a bunch of zeros, include them in the file.
        fprintf(file_pointer, '\nNormals\n\nMarker       X       Y       Z\n');
        if(number_of_normals)
            % Normal vector coordinates go here, if any...
            for(i = 1:number_of_normals)
                fprintf(file_pointer, '       %.4f       %.4f       %.4f\n', normals(i, 1), normals(i, 2), normals(i, 3));
            end
        end
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