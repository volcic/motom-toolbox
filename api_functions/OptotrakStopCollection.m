function [ fail ] = OptotrakStopCollection(  )
%OPTOTRAKSTOPCOLLECTION
% [ fail ] = OptotrakStopCollection(  )
% This function makes the system stop collecting data
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    if(new_or_old)
        fail = calllib('oapi64', 'OptotrakStopCollection');
    else
        fail = calllib('oapi', 'OptotrakStopCollection');
    end

end

