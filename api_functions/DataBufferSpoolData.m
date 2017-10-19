function [ fail, puSpoolStatus ] = DataBufferSpoolData( puSpoolStatus )
%DATABUFFERSPOOLDATA
% [ fail, puSpoolStatus ] = DataBufferSpoolData( puSpoolStatus )
% This function downloads (or 'spools') data to the locations you have initialised previously.
% This operation downloads the contents of the buffer completely until the time the funciton was called at without you having to do anything.
% Afterwards, it destroys the links to the destinations you specified, so you will have to re-initialise them
%   -> puSpoolStatus is an error indicator telling you if something went wrong during the download. 0 for everything OK, non-zero values for an error.
%       There is no definition on what the error codes are, so try using OptotrakGetErrorString()
%   Detailed explanation goes here
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    uSpoolStatus_pointer = libpointer('uint32Ptr', puSpoolStatus);

    if(new_or_old)
        fail = calllib('oapi64', 'DataBufferSpoolData', uSpoolStatus_pointer);
    else
        fail = calllib('oapi', 'DataBufferSpoolData', uSpoolStatus_pointer);
    end

    % Get updated data with the pointer
    puSpoolStatus = get(uSpoolStatus_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear uSpoolStatus_pointer;

end

