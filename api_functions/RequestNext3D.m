function [ fail ] = RequestNext3D(  )
%REQUESTNEXT3D
% [ fail ] = RequestNext3D(  )
% This function tells the Optotrak system wait until a new frame is captured and send the 3D data available.
% Make sure you wait until DataIsReady() says so, and then you can call DataReceiveNext3D().
% Also make sure that you have only one request running at the time, otherwise you will corrupt data.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    if(isunix)
        fail = calllib('liboapi', 'RequestNext3D');
    else
        if(new_or_old)
            fail = calllib('oapi64', 'RequestNext3D');
        else
            fail = calllib('oapi', 'RequestNext3D');
        end
    end
end

