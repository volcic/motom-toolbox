function [ fail, nPort1, nPort2, nPort3, nPort4 ] = OptotrakSetStroberPortTable( nPort1, nPort2, nPort3, nPort4 )
%OPTOTRAKSETSTROBERTABLE This function configures how many markers have you got on each port.
%   -> nPort1: The number of markers on Port 1.
%   -> nPort2: The number of markers on Port 2.
%   -> nPort3: The number of markers on Port 3.
%   -> nPort4: The number of markers on port 4.
% If you are using the Certus system, you're out of luck, because it doesn't have a fourth port. However, the API doesn't know that,
% and nPort4 must be set to 0.
% Particulars of strobing are set in the optotrak.ini file.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    if(new_or_old)
        fail = calllib('oapi64', 'OptotrakSetStroberPortTable', nPort1, nPort2, nPort3, nPort4);
    else
        fail = calllib('oapi', 'OptotrakSetStroberPortTable', nPort1, nPort2, nPort3, nPort4);
    end

end