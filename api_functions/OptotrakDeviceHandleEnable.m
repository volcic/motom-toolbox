function [ fail, nDeviceHandleId ] = OptotrakDeviceHandleEnable( nDeviceHandleId )
%OPTOTRAKDEVICEHANDLEENABLE
% [ fail, nDeviceHandleId ] = OptotrakDeviceHandleEnable( nDeviceHandleId )
% This function enables a device which has the handle specified in the argument
% If you want to capture data from a device, you'll need to enable it. A device can activate markers, LEDs, and TTL devices.
%   -> nDeviceHandleId is the device handle you need to specify
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    if(new_or_old)
        fail = calllib('oapi64', 'OptotrakDeviceHandleEnable', nDeviceHandleId);
    else
        fail = calllib('oapi', 'OptotrakDeviceHandleEnable', nDeviceHandleId);
    end

end

