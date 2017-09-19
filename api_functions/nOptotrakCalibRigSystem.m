function [ fail, dtCalibRigParms, pfRMSError ] = nOptotrakCalibRigSystem( dtCalibRigParms, pfRMSError )
%NOPTOTRAKCALIBRIGSYSTEM If you use more than one sensor, this is the function you need to use to align them together.
%   -> dtCalibRigParms is a structure, defined as follows:
%       char pszRawDataFile is the file name of a pre-collected raw data with the unaligned sensors
%       char pszRigidBodyFile is the rigid body definition with which the data above was collected
%       char pszInputCamFile is the file name for the unaligned camera settings
%       char pszOutputCamFile is the file name this function will write the new calibration data to.
%       char szLogFileName is the name of the log file to be written out during calibration
%       boolean bVerbose is a switch (0 vs everything else) that dumps messages to the console.
%   -> pfRMSError is where the calibration RMS error is being saved to.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    CalibRigParms_struct = libstruct('CalibRigParms', dtCalibRigParms);
    fRMSError_pointer = libpointer('singlePtr', pfRMSError);

    if(new_or_old)
        fail = calllib('oapi64', 'nOptotrakCalibRigSystem', CalibRigParms_struct, fRMSError_pointer);
    else
        fail = calllib('oapi', 'nOptotrakCalibRigSystem', CalibRigParms_struct, fRMSError_pointer);
    end

    % Get updated data with the pointer
    dtCalibRigParms = get(CalibRigParms_struct);
    pfRMSError = get(fRMSError_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear CalibRigParms_struct fRMSError_pointer;
end

