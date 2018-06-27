function [ fail ] = OptotrakDeActivateMarkers(  )
%OPTOTRAKDEACTIVATEMARKERS
% [ fail ] = OptotrakDeActivateMarkers(  )
% Turns off the IR LEDs in the Optotrak system.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.
    if(isunix)
        fail = calllib('liboapi', 'OptotrakDeActivateMarkers');
    else
        if(new_or_old)
            fail = calllib('oapi64', 'OptotrakDeActivateMarkers');
        else
            fail = calllib('oapi', 'OptotrakDeActivateMarkers');
        end
    end
end

