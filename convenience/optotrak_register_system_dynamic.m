%optotrak_register_system_dynamic.m optotrak_register_system_dynamic.mex* optotrak_register_system_dynamic.c
%OPTOTRAK_REGISTER_SYSTEM_DYNAMIC
% [fail, tolerance] = optotrak_align_system(old_camera_file_name, path_to_recording, path_to_rigid_body, new_camera_file_name, logfile_name)
% This is a C wrapper function for nOptotrakRegistergSystem(). It alllows the registration of many cameras together into a common coordinate system.
% This function supposed to handle rigid bodies that move about in the recordings.
% The problem is that the RegisterParametersStruct typedef is incorrectly read into Matlab.
% So, I made this file, which accepts the structure fields as command-line arguments. Also I hard-coded verbosity.
% Input arguments are:
%   -> old_camera_file_name is the camera parameter file the raw data was recorded with. Usually, it's 'standard'.
%   -> path_to_recording is where the raw data file is
%   -> path_to_rigid_body is either the name of the rigid body file in the rigid body directory, or the full path to the .rig file itself. Must be the same one the recording was made with.
%   -> new_camera_file is the name of the camera file the registration function is going to generate. You most probably will need to process it further, so it will align to your coordinate system.
%   -> logfile_ane, is the path or name of the log file the registration algorithm will generate.
% fail is a failure indicator. A nnonzero value of fail tells you something went wrong.
% tolerance is the introduced error is millimetres. Re-aligning the coordinate system usually results in some interpolation errors. Typically it's a fraction of a millimetre.