% DataGetNext3d.m DataGetNext3d.mex* DataGetNext3d.c
% DATAGETNEXT3D_AS_ARRAY This function is written in C, and returns 3D marker data as an x-y-z array.
% The Optotrak system will wait until the next frame is captured, and then it sends you the coordinates.
% If a marker is not visible, it will return a NaN for the corresponding markers' coordinates.
%   fail is a failure indicatior. Nonzero value means something went wrong.
%   framecounter is the nth frame this data belongs to, since initialisation.
%   position3darray is where the coordinates go, in x-y-z triplets
%   flags is the device flag indicator. Run opototrak_data_flag_decoder.m on this to see what this number holds.