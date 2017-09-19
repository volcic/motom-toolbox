function [ fail, pFlags ] = OptotrakGetProcessingFlags( pFlags )
%OPTOTRAKGETPROCESSINGFLAGS Fetches current processing flags from the system.
% The flags are binary, and you'll have to decompose them to binary in order to interpret this. Here's how:
%   -> pFlags
%       0 (0x00000000): Clear all flags
%       1 (0x00000001): OPTO_LIB_POLL_REAL_DATA: blocking mode in real-time data transfers
%       2 (0x00000002): OPTO_CONVERT_ON_HOST: Makes the raw data to be converted in the host computer, as opposed to the system. Handy if you need more performance
%       4 (0x00000004): OPTO_RIGID_ON_HOST: Makes the rigid body calculations to be done on the host computer. This also can take off computational load from the system.
%       8 (0x00000008): OPTO_USE_INTERNAL_NIF: Use the network information in the device, as opposed to reading it from a file
%      16 (0x00000010): OPTO_USE_PRIMITIVE_RIGID_BODY_ALGORITHM: Undocumented, but can guess what it does :)
%      32 (0x00000020): OPTO_RIGID_NO_UPDATE3DDATA_MISSINGIFOFFANGLE: Undocumented
%      64 (0x00000040): OPTO_RIGID_NO_UPDATE3DDATA_MISSINGIFMAXERROR: Undocumented
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    Flags_pointer = libpointer('uint32Ptr', pFlags);

    if(new_or_old)
        fail = calllib('oapi64', 'OptotrakGetProcessingFlags', Flags_pointer);
    else
        fail = calllib('oapi', 'OptotrakGetProcessingFlags', Flags_pointer);
    end

    % Get updated data with the pointer
    pFlags = get(Flags_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear Flags_pointer;
end

