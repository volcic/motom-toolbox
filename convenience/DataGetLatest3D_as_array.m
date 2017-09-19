% DataGetLatest3D_as_array.m DataGetLatest3D_as_array.mex* DataGetLatest3D_as_array.c
% DATAGETLATEST3D_AS_ARRAY This function is written in C, and returns 3D marker data as an x-y-z array.
% If a marker is not visible, it will return a NaN for the corresponding markers' coordinates.
% The Optotrak system will send the frame it just captured. If there is no new frame available, it will send the one it sent previously.
%   fail is a failure indicatior. Nonzero value means something went wrong.
%   framecounter is the nth frame this data belongs to, since initialisation.
%   position3darray is where the coordinates go, in x-y-z triplets
%   flags is the device flag indicator. Run opototrak_data_flag_decoder.m on this to see what this number holds.