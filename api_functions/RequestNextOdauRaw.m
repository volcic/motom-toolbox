function [ fail ] = RequestNextOdauRaw( nOdauId )
%REQUESTNEXTODAURAW
% [ fail ] = RequestNextOdauRaw( nOdauId )
% This function tells the Optotrak system to wait until a new frame is captured and send the data from a selected ODAU.
% Make sure you wait until DataIsReady() says so, and then you can call DataReceiveNextOdauRaw().
% Also make sure that you have only one request running at the time, otherwise you will corrupt data.
%   -> nOdauId is the ODAU selected, as follows:
%       2: ODAU1
%       3: ODAU2
%       4: ODAU3
%       5: ODAU4
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    if(isunix)
        fail = calllib('liboapi', 'RequestNextOdauRaw', nOdauId);
    else
        if(new_or_old)
            fail = calllib('oapi64', 'RequestNextOdauRaw', nOdauId);
        else
            fail = calllib('oapi', 'RequestNextOdauRaw', nOdauId);
        end
    end
end

