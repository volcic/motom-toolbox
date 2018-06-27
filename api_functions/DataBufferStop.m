function [ fail ] = DataBufferStop(  )
%DATABUFFERSTOP
% [ fail ] = DataBufferStop(  )
% ... stops the transfer of data from the Optotrak device to the computer.
% This function is useful when you want to stop transferring the data prematurely for some reason.
% You still have to wait until DataBufferWriteData() says so.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    if(isunix)
        fail = calllib('liboapi', 'DataBufferStop');
    else
        if(new_or_old)
            fail = calllib('oapi64', 'DataBufferStop');
        else
            fail = calllib('oapi', 'DataBufferStop');
        end
    end
end

