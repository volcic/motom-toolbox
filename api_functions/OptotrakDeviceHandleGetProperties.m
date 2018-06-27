function [ fail, nDeviceHandleId, grdtProperties, nProperties ] = OptotrakDeviceHandleGetProperties( nDeviceHandleId, grdtProperties, nProperties )
%OPTOTRAKDEVICEHANDLEGETPROPERTIES
% [ fail, nDeviceHandleId ] = OptotrakDeviceHandleFree( nDeviceHandleId )
% This function returns the property structure for a device that is specified with the handle.
% This can include the number of switches, location, etc.
%   -> nDeviceHandleId is the device handle that selects which device is being read.
%   -> grdtProperties is the data structure the function will write things to
%   -> nProperties is the number of properties expected to obtain.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs

    grdtProperties_pointer = libstruct('DeviceHandleProperties', grdtProperties);
    %grdtProperties_structure = libstruct('DeviceHandleProperty', grdtProperties);
    %grdtProperties_pointer = libpointer('voidPtr', grdtProperties_structure);
    
    if(isunix)
        fail = calllib('liboapi', 'OptotrakDeviceHandleGetProperties', nDeviceHandleId, grdtProperties_pointer, nProperties);
    else
        if(new_or_old)
            fail = calllib('oapi64', 'OptotrakDeviceHandleGetProperties', nDeviceHandleId, grdtProperties_pointer, nProperties);
        else
            fail = calllib('oapi', 'OptotrakDeviceHandleGetProperties', nDeviceHandleId, grdtProperties_pointer, nProperties);
        end
    end

    % Get updated data with the pointer
    %grdtProperties_structure = get(grdtProperties_pointer, 'Value');
    %grdtProperties = get(grdtProperties_structure);
    grdtProperties = get(grdtProperties_pointer);

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear grdtProperties_pointer;
end

