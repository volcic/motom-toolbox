function [ fail, nDeviceHandleId, uTime_ms ] = OptotrakDeviceHandleSetBeeper( nDeviceHandleId, uTime_ms )
%OPTOTRAKDEVICEHANDLESETBEEPER
% [ fail, nDeviceHandleId, uTime_ms ] = OptotrakDeviceHandleSetBeeper( nDeviceHandleId, uTime_ms )
% This function makes the selected device go beep for a specified time.
% Please exercise caution when using this function. The beeper can be very annoying.
%   -> nDeviceHandleId is the device identifier
%   -> uTime_ms is the time in milliseconds the beep is on
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    if(isunix)
        fail = calllib('liboapi', 'OptotrakDeviceHandleSetBeeper', nDeviceHandleId, uTime_ms );
    else
        if(new_or_old)
            fail = calllib('oapi64', 'OptotrakDeviceHandleSetBeeper', nDeviceHandleId, uTime_ms );
        else
            fail = calllib('oapi', 'OptotrakDeviceHandleSetBeeper', nDeviceHandleId, uTime_ms );
        end
    end

end

