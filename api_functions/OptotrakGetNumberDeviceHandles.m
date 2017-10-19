function [ fail, pnDeviceHandles ] = OptotrakGetNumberDeviceHandles( pnDeviceHandles )
%OPTOTRAKGETNUMBERDEVICEHANDLES
% [ fail, pnDeviceHandles ] = OptotrakGetNumberDeviceHandles( pnDeviceHandles )
% This function tells you how many devices the Optotrak SCU has detected.
%You'll need this to call OptotrakGetDeviceHandles(...).
%   -> pnDeviceHandles is the variable the number of devices will be stored into.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    nDeviceHandles_pointer = libpointer('int32Ptr', pnDeviceHandles);

    if(new_or_old)
        fail = calllib('oapi64', 'OptotrakGetNumberDeviceHandles', nDeviceHandles_pointer);
    else
        fail = calllib('oapi', 'OptotrakGetNumberDeviceHandles', nDeviceHandles_pointer);
    end

    % Get updated data with the pointer
    pnDeviceHandles = get(nDeviceHandles_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear nDeviceHandles_pointer;
end

