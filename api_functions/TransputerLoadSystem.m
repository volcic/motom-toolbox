function [ fail, pszNifFile ] = TransputerLoadSystem( pszNifFile )
%TRANSPUTERLOADSYSTEM
% [ fail, pszNifFile ] = TransputerLoadSystem( pszNifFile )
% Loads system configuration. When loading the .nif
%files, make sure that the extension is missed off. i.e.
%TransputerLoadSystem('blabla') is loading blabla.nif.
%Make sure you add about 2 seconds delay after the function so the
%Optotrak system can work properly.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    szNifFile_pointer = libpointer('cstring', pszNifFile);

    if(isunix)
        fail = calllib('liboapi', 'TransputerLoadSystem', szNifFile_pointer);
    else
        if(new_or_old)
            fail = calllib('oapi64', 'TransputerLoadSystem', szNifFile_pointer);
        else
            fail = calllib('oapi', 'TransputerLoadSystem', szNifFile_pointer);
        end
    end
    % Get updated data with the pointer
    pszNifFile = get(szNifFile_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear szNifFile_pointer;

end

