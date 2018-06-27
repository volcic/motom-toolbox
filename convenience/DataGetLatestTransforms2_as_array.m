% DataGetLatestTransforms2_as_array.m DataGetLatestTransforms2_as_array.mex* DataGetLatestTransforms2_as_array.c
% DATAGETLATESTTRANSFORMS2_AS_ARRAY
% [fail, framecounter, translation, rotation, positions] = DataGetLatestTransforms2_as_array( number_of_markers )
% This function is written in C, and it converts the position of all the rigid bodies in the system that has already been captured.
% It also can return the marker position data as X-Y-Z triplets for each sensor, provided you specify how many markers you want to extract.
% If the markers are not visible, or the rigid body couldn't be transformed, it returns a NaN.
% Note that this only works with Euler angles, the other transform types are not supported.
% Input arguments are:
%   -> number_of_markers is round number, telling how many X-Y-Z positions you want to extract. If you don't want any, just give it a 0.
% Output arguments are:
%   -fail is the outcome of the underlying C function. 0 for all good, nonzero for fail.
%   -framecounter is the number of frames since initialisation
%   -translation is an x-y-z triplet for each rigid body for the centroid of the rigid body
%   -rotation is a roll-pitch-yaw triplet for each rigid body, in radians
%   -positions is for each marker's X-Y-Z tiplet. The number of markers must be specified in the input argument.