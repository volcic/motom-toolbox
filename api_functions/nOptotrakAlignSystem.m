function [ fail, dtAlignParams, pfRMSError ] = nOptotrakAlignSystem( dtAlignParams, pfRMSError )
%NOPTOTRAKALIGNSYSTEM
% [ fail, dtAlignParams, pfRMSError ] = nOptotrakAlignSystem( dtAlignParams, pfRMSError )
% This function changes the Optotrak's coordinate system, and saves this to a specified camera parameter file.
% Basically, you use a previous recording of a known rigid body to align the camera's coordinate system to the rigid body's corrodinate system.
%   -> dtAlignParams is a parameter structure. It is initialised as follows:
%       char szDataFile is a data file name with a recording of unaligned parameters
%       char szRigidBodyFile is the rigid body file name used for the calibration
%       char szInputCamFile is the file name for the camera settings, prior to alignment
%       char szOutputCamFile is the name of the calibrated camera file which this function will generate
%       char szLogFileName is the calibration log file
%       boolean bVerbose is a binary (0 - anything else) field, which toggles calibration information to the console.
%   -> pfRMSError is a variable where the RMS error of the calibration will be stored.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    AlignParams_struct = libstruct('AlignParametersStruct', dtAlignParams);
    fRMSError_pointer = libpointer('singlePtr', pfRMSError);
    if(isunix)
        fail = calllib('liboapi', 'nOptotrakAlignSystem', AlignParams_struct, fRMSError_pointer);
    else
        if(new_or_old)
            fail = calllib('oapi64', 'nOptotrakAlignSystem', AlignParams_struct, fRMSError_pointer);
        else
            fail = calllib('oapi', 'nOptotrakAlignSystem', AlignParams_struct, fRMSError_pointer);
        end
    end

    % Get updated data with the pointer
    dtAlignParams = get(AlignParams_struct);
    pfRMSError = get(fRMSError_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear AlignParams_struct fRMSError_pointer;

end

