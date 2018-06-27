% optotrak_convert_raw_file_to_position3d_array.m optotrak_convert_raw_file_to_position_array.mex* optotrak_convert_raw_file_to_position_array.c
% OPTOTRAK_CONVERT_RAW_FILE_TO_POSITION3D_ARRAY
% [fail, position3d_array] = optotrak_convert_raw_file_to_position3d_array(input_file_name)
% This function reads a raw data file, and it converts the raw (or centroid) data to X-Y-Z triplets for each marker.
% Note that the system must be properly initialised first, as the number of markers and the camera file has to be loaded to the system
% Input arguments are:
%   -> input_file_name is the file name with path, to the raw data file you want to process.
% return values are:
% -fail is 0 when everything went well. You will get error messages if something failed during the conversion process
% -position3d_array is an array where each row is one frame, and each three columns are X-Y-Z triplets for a marker. i.e marker 1's Z coordinate is column 3, etc.
