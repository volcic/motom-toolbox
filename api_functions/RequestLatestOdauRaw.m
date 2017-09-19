function [ fail ] = RequestLatestOdauRaw( nOdauId )
%REQUESTLATESTODAURAW This function tells the Optotrak system to prepare to send the freshest data avilable from a selected ODAU.
% Make sure you wait until DataIsReady() says so, and then you can call DataReceiveLatestOdauRaw().
% Also make sure that you have only one request running at the time, otherwise you will corrupt data.
%   -> nOdauId is the ODAU selected, as follows:
%       2: ODAU1
%       3: ODAU2
%       4: ODAU3
%       5: ODAU4
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    if(new_or_old)
        fail = calllib('oapi64', 'RequestLatestOdauRaw', nOdauId);
    else
        fail = calllib('oapi', 'RequestLatestOdauRaw', nOdauId);
    end

end

