function [ fail, nDeviceHandleId, pnProperties ] = OptotrakDeviceHandleGetNumberProperties( nDeviceHandleId, pnProperties )
%OPTOTRAKDEVICEHANDLEGETNUMBERPROPERTIES
% [ fail, nDeviceHandleId ] = OptotrakDeviceHandleFree( nDeviceHandleId )
% This function tells you how many properties have been assigned to this device.
% This is useful if you need to pre-allocate memory to store the device properties into.
%   -> nDeviceHandleId is the device handle number
%   -> pnProperties is where the number of properties go, and you can use optotrak_device_handle_property_decoder() to see what this is.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    nProperties_pointer = libpointer('int32', pnProperties);

    if(isunix)
        fail = calllib('liboapi', 'OptotrakDeviceHandleGetNumberProperties', nDeviceHandleId, nProperties_pointer);
    else
        if(new_or_old)
            fail = calllib('oapi64', 'OptotrakDeviceHandleGetNumberProperties', nDeviceHandleId, nProperties_pointer);
        else
            fail = calllib('oapi', 'OptotrakDeviceHandleGetNumberProperties', nDeviceHandleId, nProperties_pointer);
        end
    end
    % Get updated data with the pointer
    pnProperties = get(nProperties_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear nProperties_pointer;
end

