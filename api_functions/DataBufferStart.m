function [ fail ] = DataBufferStart(  )
%DATABUFFERSTART This function starts the downloading ('spooling') the data from the Optotrak device to all the allocated locations on the host computer.
% Use this function together with DataBufferWriteData() and DataBufferStop().
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    if(new_or_old)
        fail = calllib('oapi64', 'DataBufferStart');
    else
        fail = calllib('oapi', 'DataBufferStart');
    end

end

