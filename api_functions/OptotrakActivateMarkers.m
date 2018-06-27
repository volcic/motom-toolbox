function [ fail ] = OptotrakActivateMarkers()
%OPTOTRAKACTIVATEMARKERS
% [ fail ] = OptotrakActivateMarkers()
% Turns on the IR leds so tracking them could be
%started. There is some delay between calling the function and the markers
%being switched on. This can create some missing data at the beginning of
%acquisition.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    if(isunix)
        fail = calllib('liboapi', 'OptotrakActivateMarkers');
    else
        if(new_or_old)
            fail = calllib('oapi64', 'OptotrakActivateMarkers');
        else
            fail = calllib('oapi', 'OptotrakActivateMarkers');
        end
    end

end

