function [ fail, nDeviceHandleId, grdtProperties, nProperties ] = OptotrakDeviceHandleSetProperties( nDeviceHandleId, grdtProperties, nProperties )
%OPTOTRAKDEVICEHANDLESETPROPERTIES
% [ fail, nDeviceHandleId, grdtProperties, nProperties ] = OptotrakDeviceHandleSetProperties( nDeviceHandleId, grdtProperties, nProperties )
% This function allows you to save properties into the device. This is done via the property structure.
% It is advisable to read the properties out with OptotrakDeviceHandleGetProperties(...), and then update it accordingly before writing its contents with this function.
%   -> nDeviceHandleId is the handle of the selected device
%   -> grdtProperties is the property structure to be written
%   -> nProperties is the size of the property structute. This is useful if you want to preallocate memory
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    rdtProperties_pointer = libstruct('DeviceHanleProperty', grdtProperties);

    if(isunix)
        fail = calllib('liboapi', 'OptotrakDeviceHandleSetProperties', nDeviceHandleId, rdtProperties_pointer, nProperties);
    else
        if(new_or_old)
            fail = calllib('oapi64', 'OptotrakDeviceHandleSetProperties', nDeviceHandleId, rdtProperties_pointer, nProperties);
        else
            fail = calllib('oapi', 'OptotrakDeviceHandleSetProperties', nDeviceHandleId, rdtProperties_pointer, nProperties);
        end
    end

    % Get updated data with the pointer
    grdtProperties = get(rdtProperties_pointer);

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear rdtProperties_pointer;
end

