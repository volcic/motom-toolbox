function [ fail ] = RequestNextCentroid(  )
%REQUESTNEXTCCENTROID
% [ fail ] = RequestNextCentroid(  )
% This function tells the Optotrak system wait until a new frame is captured and send the centroid data available.
% Make sure you wait until DataIsReady() says so, and then you can call DataReceiveNextCentroid().
% Also make sure that you have only one request running at the time, otherwise you will corrupt data.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    if(new_or_old)
        fail = calllib('oapi64', 'RequestNextCentroid');
    else
        fail = calllib('oapi', 'RequestNextCentroid');
    end

end

