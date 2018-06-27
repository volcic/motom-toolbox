function [ fail ] = TransputerShutdownSystem()
%TRANSPUTERSHUTDOWNSYSTEM
% [ fail ] = TransputerShutdownSystem()
% If you couldn't guess what this function does from its name, let me explain.
% If this was a nuclear reactor, this would be the equivalent of the SCRAM
% (Safety Rope-Cutting Axe-man) process, which gradually slows down and
% kills off the sustained chain reaction in the reactor core, which in turn
% minimises its heat output.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

%If you didn't get it from this either, well, it shuts down the Optotrak
%system.

%There are no arguments for this.
    if(isunix)
        fail = calllib('liboapi', 'TransputerShutdownSystem');
    else
        if(new_or_old)
            fail = calllib('oapi64', 'TransputerShutdownSystem');
        else
            fail = calllib('oapi', 'TransputerShutdownSystem');
        end
    end
end

