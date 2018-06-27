function [ fail, nNumSwitches, pbSwtichData ] = RetrieveSwitchData( nNumSwitches, pbSwtichData )
%RETRIEVESWITCHDATA
% [ fail, nNumSwitches, pbSwtichData ] = RetrieveSwitchData( nNumSwitches, pbSwtichData )
% This is the function that allows you to get the states of the switches.
% Note that the switches are being monitored even after the data acquisition stopped. If you want to reset the switches,
% you will have to re-initialise the system.
%   -> nNumSwitches is the number of switches 
%   -> pbSwtichData is where the switch states will be loaded to.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    bSwtichData_pointer = libpointer('uint8Ptr', pbSwtichData); %This was 'boolean', but according to ndtypes.h it's just char.

    if(isunix)
        fail = calllib('liboapi', 'RetrieveSwitchData', nNumSwitches, bSwtichData_pointer);
    else
        if(new_or_old)
            fail = calllib('oapi64', 'RetrieveSwitchData', nNumSwitches, bSwtichData_pointer);
        else
            fail = calllib('oapi', 'RetrieveSwitchData', nNumSwitches, bSwtichData_pointer);
        end
    end
    % Get updated data with the pointer
    pbSwtichData = get(bSwtichData_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear bSwtichData_pointer;
end

