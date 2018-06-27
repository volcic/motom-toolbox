function [ fail ] = OptotrakSaveAutoScale( )
%OPTOTRAKSAVEAUTOSCALE
% [ fail ] = OptotrakSaveAutoScale( )
% This function saves the autoscale data into the device's non-volatile memory.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    if(isunix)
        fail = calllib('liboapi', 'OptotrakSaveAutoScale');
    else
        if(new_or_old)
            fail = calllib('oapi64', 'OptotrakSaveAutoScale');
        else
            fail = calllib('oapi', 'OptotrakSaveAutoScale');
        end
    end
end

