function [ fail ] = RequestLatestCentroid(  )
%REQUESTLATESTCENTROID
% [ fail ] = RequestLatestCentroid(  )
% This function tells the Optotrak system to prepare to send the freshest centroid data available.
% Make sure you wait until DataIsReady() says so, and then you can call DataReceiveLatestCentroid().
% Also make sure that you have only one request running at the time, otherwise you will corrupt data.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    if(isunix)
        fail = calllib('liboapi', 'RequestLatestCentroid');
    else
        if(new_or_old)
            fail = calllib('oapi64', 'RequestLatestCentroid');
        else
            fail = calllib('oapi', 'RequestLatestCentroid');
        end
    end
end

