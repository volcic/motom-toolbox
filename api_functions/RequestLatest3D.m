function [ fail ] = RequestLatest3D(  )
%REQUESTLATEST3D
% [ fail ] = RequestLatest3D(  )
% This function tells the Optotrak system to prepare to send the freshest 3D data available.
% Make sure you wait until DataIsReady() says so, and then you can call DataReceiveLatest3D().
% Also make sure that you have only one request running at the time, otherwise you will corrupt data.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    if(isunix)
        fail = calllib('liboapi', 'RequestLatest3D');
    else
        if(new_or_old)
            fail = calllib('oapi64', 'RequestLatest3D');
        else
            fail = calllib('oapi', 'RequestLatest3D');
        end
    end

end

