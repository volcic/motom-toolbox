function [ fail, nOdauId, uTimer, uMode, ulVal ] = OdauSetTimer( nOdauId, uTimer, uMode, ulVal )
%ODAUSETTIMER
% [ fail, nOdauId, uTimer, uMode, ulVal ] = OdauSetTimer( nOdauId, uTimer, uMode, ulVal )
% This function allows you to set the internal user timer on the ODAU.
%   -> nOdauId is the ODAU selected, as follows:
%       2: ODAU1
%       3: ODAU2
%       4: ODAU3
%       5: ODAU4
%   -> uTimer is the user timer. Currently the only legal value is 2. (ODAU_TIMER2)
%   -> uMode sets the operating mode of the timer, as follows, although it's not very well documented:
%       1: ODAU_TIMER_ONE_SHOT is for monostable operation
%       2: ODAU_TIMER_RATE_GEN is presumably for setting frequency instead of period time
%       3: ODAU_TIMER_SQUARE_WAVE is to be used as a function generator
%       4: ODAU_TIMER_RETRIGGER is undocumented.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    if(isunix)
        fail = calllib('liboapi', 'OdauSetTimer', nOdauId, uTimer, uMode, ulVal);
    else
        if(new_or_old)
            fail = calllib('oapi64', 'OdauSetTimer', nOdauId, uTimer, uMode, ulVal);
        else
            fail = calllib('oapi', 'OdauSetTimer', nOdauId, uTimer, uMode, ulVal);
        end
    end
end

