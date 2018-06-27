% RigidBodyAddFromFile.m RigidBodyAddFromFile.mex* RigidBodyAddFromFile.c
% RIGIDBODYADDFROMFILE_EULER
% [fail] = RigidBodyAddFromFile_euler( rigid_body_id, start_marker, rigid_body_file )
% This function is written in C, and it adds a pre-defined rigid body from a file for tracking.
% Note that the initial position of the rigid body is the origin, so all rigid body movements are recorded with respect to this position.
% Input arguments are:
%   -> rigid_body_id is a number you can assign to the rigid body. Please make sure that this is sequential, and starts from 0.
%   -> start_marker is the first marker of the rigid body. For instance, if you have 4 markers for tracking something else, and a rigid body, set this to 5.
%   -> rigid_body_file is a file name without extension, and the default search path is the rigid directory (for Windows, by default, it's C:\ndigital\rigid)
% Output arguments are:
%   -fail, which is the return value of the underlying function, nonzero value if it failed.