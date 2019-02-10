function [virtual_marker_coords] = optotrak_get_virtual_marker_coords(virtual_marker_definition, translation, rotation)
    %OPTOTRAK_GET_VIRTUAL_MARKER_COORDS
    % [virtual_marker_coords] = optotrak_get_virtual_marker_coords(virtual_marker_definition, translation, rotation)
    % This is function that calculates the X-Y-Z coordinates of a virtual marker, using the given virtual marker definition and the translation and rotation matrices.
    % WARNING: Nothing checks whether the rigid body the virtual marker definition was created with is actually the same as the input of this function.
    % This function is designed to get a single virtual marker's coordinates on a rigid body transform that can be many frames. So if you want many virtual markers for the same rigid body, simply execute this funciton with different virtual marker definitions.
    % Algorithm from: http://planning.cs.uiuc.edu/node102.html, or pretty much any textbook on the subject.
    % Input arguments are:
    %   -> virtual marker definition is a 1-by-6 vector, containing the following:
    %       -X-offset, which is the difference between the virtual marker and centroid X coordinates
    %       -Y-offset, which is the difference between the virtual marker and centroid Y coordinates
    %       -Z-offset, which is the difference between the virtual marker and centroid Z coordinates
    %       -roll, wich is the rotation along the Z axis in radians of the rigid body at the time of declaration
    %       -pitch, wich is the rotation along the Y axis in radians of the rigid body at the time of declaration
    %       -yaw, wich is the rotation along the X axis in radians of the rigid body at the time of declaration
    %   -> translation is the X-Y-Z triplet of the current location of the rigid body
    %   -> rotation is the current roll-pitch-yaw orientation of the rigid body, in radians
    % virtual_marker_coords contains the calculated virtual marker coordinates, as an X-Y-Z triplet. Each row is a separate frame.
    
        %Do some sanity checks
        [virtual_marker_frames, virtual_marker_entries] = size(virtual_marker_definition);
        [translation_frames, translation_entries] = size(translation);
        [rotation_frames, rotation_entries] = size(rotation);
    
        %There can be only one virtual marker definition.
        if(virtual_marker_frames > 1)
            error('This function can only process one virtual marker at a time.')
        end
    
        %Is it the correct length?
        if(virtual_marker_entries ~= 6)
            error('The virtual marker definition must be a vector, with exactly six entries.')
        end
    
        %Are we being fed triplets?
        if( (translation_entries ~= 3) || (rotation_entries ~= 3) )
            error('Please execute this function on a single rigid body.')
        end
    
        %Is the rigid body data OK?
        if(translation_frames ~= rotation_frames)
            error('Make sure you use that the translation and rotation arrays have the same number of frames')
        end
        
        %preallocate variables used to store/manipulate data in the loop.
        virtual_marker_coords = zeros(translation_frames, 3);
       
        % This is the rotation the rigid body did since the definition of the virtual marker.
        relative_rotation = repmat(virtual_marker_definition(4:6), translation_frames, 1) - rotation;
        

        %Okay, now we can work.
        for(i=1:translation_frames)
            yaw = relative_rotation(i, 3); % the rotation along the X axis, according to NDI's convention
            pitch = relative_rotation(i, 2); % The rotation along the Y axis, according to NDI's convention.
            roll = relative_rotation(i, 1); % The rotation along the Z axis, according to NDI's convention.

            %This can be simplified, and you can boost performance. A lot.
            %We now build three rotation matrices.

            rotation_matrix_roll = [
                cos(roll), -1*sin(roll), 0;
                sin(roll), cos(roll), 0;
                0, 0, 1;
            ];

            rotation_matrix_pitch = [
                cos(pitch), 0, sin(pitch);
                0, 1, 0;
                -1*sin(pitch), 0, cos(pitch);
            ];

            rotation_matrix_yaw = [
                1, 0, 0;
                0, cos(yaw), -1*sin(yaw);
                0, sin(yaw), cos(yaw);
            ];


            % Let's check what's wrong. Uncommenting these will bypass the
            % rotation in question, without the matrix operation being
            % affected.
            %rotation_matrix_roll = eye(3);
            %rotation_matrix_pitch = eye(3);
            %rotation_matrix_yaw = eye(3);


            %which we will use to re-calculate the location of the virtual marker
            %Note that the matrices are multiplied in reverse order! This was fun to figure out. RTFM :)
            % RTFM #2: If you want to transform a point attached to a rigid body, do the inverse of the rotation matrix.
            final_rotation_matrix = inv(rotation_matrix_yaw * rotation_matrix_pitch * rotation_matrix_roll);
            % Beware: the coordinates are read out as a column vector, but the function outputs it as a row vector.
            rotated_definition_offset = final_rotation_matrix * (virtual_marker_definition(1:3))';
            
            %And now, we translate the rotated coordinates.
            virtual_marker_coords(i, :) = rotated_definition_offset' + translation(i, :);
            
            % Print some diagnostic information
            % This is for debugging the funny angle anomaly.
%             fprintf('R:(%0.2f + %0.2f)=%0.2f deg; P:(%0.2f - %0.2f)=%0.2f deg; Y:(%0.2f - %0.2f)=%0.2f deg. ', ...
%             virtual_marker_definition(4)/pi*180, rotation(i, 1)/pi*180, roll/pi*180, ...
%             virtual_marker_definition(5)/pi*180, rotation(i, 2)/pi*180, pitch/pi*180, ...
%             virtual_marker_definition(6)/pi*180, rotation(i, 3)/pi*180, yaw/pi*180);
%             fprintf('Rotated coordinates are: %0.1f, %0.1f, %0.1f.\n', rotated_definition_offset(1), rotated_definition_offset(2), rotated_definition_offset(3));           
           



        end    
    end