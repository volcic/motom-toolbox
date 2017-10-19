%optotrak_align_coordinate_system.m optotrak_align_coordinate_system.mex* optotrak_align_coordinate_system.c
%OPTOTRAK_ALIGN_COORDINATE_SYSTEM
% [ tolerance ] = optotrak_align_coorindate_system( old_camera_file_name, path_to_recording, path_to_rigid_body, new_camera_file, logfile_name )
% This is a wrapper function for nOptotrakAlignSystem(), The problem is that the AlignParametersStruct typedef is incorrectly read into Matlab.
% So, I made this file, which accepts the structure fields as command-line arguments. Also I hard-coded verbosity.
% Matlab declaration is:
% [fail, tolerance] = optotrak_align_system(old_camera_file_name, path_to_recording, path_to_rigid_body, new_camera_file_name, logfile_name)
% Input arguments are:
%   -> old_camera_file_name is the camera parameter file the raw data was recorded with. Usually, it's 'standard'.
%   -> path_to_recording is where the raw data file is
%   -> path_to_rigid_body is either the name of the rigid body file in the rigid body directory, or the full path to the .rig file itself. Must be the same one the recording was made with.
%   -> new_camera_file is the name of the camera file the alignment function is going to generate. You will need to use this in your experiments later-on.
%   -> logfile_ane, is the path or name of the log file the alignment algorithm will generate.
% tolerance is the introduced error is millimetres. Re-aligning the coordinate system usually results in some interpolation errors. Typically it's a fraction of a millimetre.