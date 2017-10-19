function [ fail, pnCurrentMarkerType, pnCurrentMarkerWaveLength, pnCurrentModelType, szStatus, nStatusLength ] = OptotrakGetCameraParameterStatus( pnCurrentMarkerType, pnCurrentMarkerWaveLength, pnCurrentModelType, szStatus, nStatusLength )
%OPTOTRAKGETCAMERAPARAMETERSTATUS
% [ fail, pnCurrentMarkerType, pnCurrentMarkerWaveLength, pnCurrentModelType, szStatus, nStatusLength ] = OptotrakGetCameraParameterStatus( pnCurrentMarkerType, pnCurrentMarkerWaveLength, pnCurrentModelType, szStatus, nStatusLength )
% This function tells you how your cameras
%are set up, including marker info. The API manual is not very helpful with
%this.
%   -> pnCurrentMarkerType is the marker type according to the manual.
%   -> pnCurrentMarkerWaveLength is the 'wavelength type'.
%   -> pnCurrentModelType can be 'model 1', 'model 2', for example.
%   -> szStatus is the status string
%   -> nStatusLength is the length of the previous status string.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    nCurrentMarkerType_pointer = libpointer('int32Ptr', pnCurrentMarkerType);
    nCurrentMarkerWaveLength_pointer = libpointer('int32Ptr', pnCurrentMarkerWaveLength);
    nCurrentModelType_pointer = libpointer('int32Ptr', pnCurrentModelType);
    szStatus_pointer = libpointer('cstring', szStatus);
    
    if(new_or_old)
        fail = calllib('oapi64', 'OptotrakGetCameraParameterStatus', nCurrentMarkerType_pointer, nCurrentMarkerWaveLength_pointer, nCurrentModelType_pointer, szStatus_pointer, nStatusLength);
    else
        fail = calllib('oapi', 'OptotrakGetCameraParameterStatus', nCurrentMarkerType_pointer, nCurrentMarkerWaveLength_pointer, nCurrentModelType_pointer, szStatus_pointer, nStatusLength);
    end

    % Get updated data with the pointer
    pnCurrentMarkerType = get(nCurrentMarkerType_pointer, 'Value');
    pnCurrentMarkerWaveLength = get(nCurrentMarkerWaveLength_pointer, 'Value');
    pnCurrentModelType = get(nCurrentModelType_pointer, 'Value');
    szStatus = get(szStatus_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear nCurrentMarkerType_pointer nCurrentMarkerWaveLength_pointer nCurrentModelType_pointer szStatus_pointer;
end

