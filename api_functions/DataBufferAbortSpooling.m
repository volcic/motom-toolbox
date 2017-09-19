function [ fail ] = DataBufferAbortSpooling(  )
%DATABUFFERABORTSPOOLING This function allows you to stop tranfserring data (i.e. 'spooling') the associated destination from the Optotrak system
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    if(new_or_old)
        fail = calllib('oapi64', 'DataBufferAbortSpooling');
    else
        fail = calllib('oapi', 'DataBufferAbortSpooling');
    end


end

