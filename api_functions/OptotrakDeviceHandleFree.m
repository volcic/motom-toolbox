function [ fail, nDeviceHandleId ] = OptotrakDeviceHandleFree( nDeviceHandleId )
%OPTOTRAKDEVICEHANDLEFREE
% [ fail, nDeviceHandleId ] = OptotrakDeviceHandleFree( nDeviceHandleId )
% This function frees up a device handle, and some memory with it.
% If you decide to re-allocate a device handle for this device, it will get a differen handle.
%   -> nDeviceHandleId is the device handle you no longer use and you want the system to free up the allocated memory.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    if(new_or_old)
        fail = calllib('oapi64', 'OptotrakDeviceHandleFree', nDeviceHandleId);
    else
        fail = calllib('oapi', 'OptotrakDeviceHandleFree', nDeviceHandleId);
    end


end

