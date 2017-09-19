% optotrak_convert_raw_file_to_position3d_array.m optotrak_convert_raw_file_to_position3d_array.mex* optotrak_convert_raw_file_to_position3d_array.c
% OPTOTRAK_CONVERT_RAW_FILE_TO_RIGID_EULER_ARRAY This function reads the raw data, and executes rigid body transforms.
% Note that you must have the system properly initialised and your rigid bodies loaded/defined if you want this function to work.
%
% [fail, position3d_array, translation_array, rotation_array] = optotrak_convert_raw_file_to_rigid_euler_array(input_file_name)
%
% Input arguments are:
%   -> input_file_name is the name and path to the raw data you want to process.
% Returns:
% -fail is 0 when everything went well. You will get error messages if something failed during the conversion process
% -position3d_array is an array where each row is one frame, and each three columns are X-Y-Z triplets for a marker. i.e marker 1's Z coordinate is column 3, etc.
% -translation_array is the X-Y-Z coordinates of the rigid body. Each row is a frame, and each triplet belongs to a rigid body.
% -rotation array is the roll-pitch-yaw rotation angles IN RADIANS. Each row is a frame, and each triplet belongs to a rigid body.
