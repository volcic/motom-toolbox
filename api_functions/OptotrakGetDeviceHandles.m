function [ fail, grdtDeviceHandles, nDeviceHandles, puFlags ] = OptotrakGetDeviceHandles( grdtDeviceHandles, nDeviceHandles, puFlags )
%OPTOTRAKGETDEVICEHANDLES
% [ fail, grdtDeviceHandles, nDeviceHandles, puFlags ] = OptotrakGetDeviceHandles( grdtDeviceHandles, nDeviceHandles, puFlags )
% This function finds out what devices have been connected to the Optotrak SCU.
% You need to know the EXACT number of devices connected before calling this function. You can find this out by calling OptotrakGetNumberDeviceHandles(...)
%   -> grdtDeviceHandles is a structure array with all the different things discovered by the Optotrak SCU
%   The statuses are as follows:
%       0: DH_STATUS_UNOCCUPIED
%       1: DH_STATUS_OCCUPIED
%       2: DH_STATUS_INITALIZED
%   -> nDeviceHandles tells the function how much memory is available for the structure array
%   -> puFlags is where the flags are being put by the function. It's a binary mask, so if you only see numbers here, they correspond to:
%       16: OPTO_TOOL_CONFIG_CHANGED_FLAG is set when nDeviceHandles do not match the number of devices connected to the system
%
%  If multiple flags are set, then these numbers add together.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    rdtDeviceHandles_pointer = libpointer('DeviceHandlePtr', grdtDeviceHandles);
    uFlags_pointer = libpointer('uint32Ptr', puFlags);

    if(isunix)
        fail = calllib('liboapi', 'OptotrakGetDeviceHandles', rdtDeviceHandles_pointer, nDeviceHandles, uFlags_pointer);
    else
        if(new_or_old)
            fail = calllib('oapi64', 'OptotrakGetDeviceHandles', rdtDeviceHandles_pointer, nDeviceHandles, uFlags_pointer);
        else
            fail = calllib('oapi', 'OptotrakGetDeviceHandles', rdtDeviceHandles_pointer, nDeviceHandles, uFlags_pointer);
        end
    end

    % Get updated data with the pointer
    grdtDeviceHandles = get(rdtDeviceHandles_pointer, 'Value');
    puFlags = get(uFlags_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear rdtDeviceHandles_pointer uFlags_pointer;
end

