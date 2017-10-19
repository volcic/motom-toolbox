function [ fail, nDevice, bEnable ] = OptotrakEnableWireless( nDevice, bEnable )
%OPTOTRAKENABLEWIRELESS
% [ fail, nDevice, bEnable ] = OptotrakEnableWireless( nDevice, bEnable )
% This function enables the wireless communications facilities. You need this to detect wireless devices.
%   -> nDevices is not implemented. They ask you to set it to -1 all the time.
%   -> bEnable is a boolean which enables (1) and disables (0) wireless
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    if(new_or_old)
        fail = calllib('oapi64', 'OptotrakEnableWireless', nDevice, bEnable);
    else
        fail = calllib('oapi', 'OptotrakEnableWireless', nDevice, bEnable);
    end

end

