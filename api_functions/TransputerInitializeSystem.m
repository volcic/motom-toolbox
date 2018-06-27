function [ fail ] = TransputerInitializeSystem( uFlags )
%TRANSPUTERINITIALIZESYSTEM
% [ fail ] = TransputerInitializeSystem( uFlags )
% ... checks if the hardware is compatible with this
%API, and then initialises the system.
%   uFlags is a binary mask, you would normally have defines for this in the C API, but here:
%   -> 0 for no logging
%   -> 1 for error logs to 'opto.err'
%   -> 2 errors and messages to 'opto.err'
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    if(isunix)
        fail = calllib('liboapi','TransputerInitializeSystem', uFlags);
    else
        if(new_or_old)
            fail = calllib('oapi64','TransputerInitializeSystem', uFlags);
        else
            fail = calllib('oapi','TransputerInitializeSystem', uFlags);
        end
    end
end

