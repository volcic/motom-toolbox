function [ fail ] = RequestNextRaw(  )
%REQUESTNEXTRAW
% [ fail ] = RequestNextRaw(  )
% This function tells the Optotrak system to wait until a new frame is captured and send the full raw data available.
% Make sure you wait until DataIsReady() says so, and then you can call DataReceiveNextRaw().
% Also make sure that you have only one request running at the time, otherwise you will corrupt data.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    if(new_or_old)
        fail = calllib('oapi64', 'RequestNextRaw');
    else
        fail = calllib('oapi', 'RequestNextRaw');
    end

end

