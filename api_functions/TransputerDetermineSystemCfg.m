function [fail, pszInputLogFile] = TransputerDetermineSystemCfg(pszInputLogFile)
%TRANSPUTERDETERMINESYSTEMCFG
% fail, pszInputLogFile] = TransputerDetermineSystemCfg(pszInputLogFile)
% Whatever you did to the device, this needs to be called first.
%   pszInputLogFile is the path for the log
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    szInputLogFile_pointer = libpointer('cstring', pszInputLogFile);

    if(isunix)
        fail = calllib('liboapi', 'TransputerDetermineSystemCfg', szInputLogFile_pointer);
    else
        if(new_or_old())
            fail = calllib('oapi64', 'TransputerDetermineSystemCfg', szInputLogFile_pointer);
        else
            fail = calllib('oapi', 'TransputerDetermineSystemCfg', szInputLogFile_pointer);
        end
    end

    % Get updated data with the pointer
    pszInputLogFile = get(szInputLogFile_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear szInputLogFile_pointer;
end

