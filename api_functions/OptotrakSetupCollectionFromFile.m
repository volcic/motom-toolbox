function [ fail, pszCollectFile ] = OptotrakSetupCollectionFromFile( pszCollectFile )
%OPTOTRAKSETUPCOLLECTIONFROMFILE Configures and initialises the Optotrak system from a specified config file. I added a sample config file in the examples directory
%   -> pszCollectFile is a file name.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    szCollectFile_pointer = libpointer('cstring', pszCollectFile);

    if(new_or_old)
        fail = calllib('oapi64', 'OptotrakSetupCollectionFromFile', szCollectFile_pointer);
    else
        fail = calllib('oapi', 'OptotrakSetupCollectionFromFile', szCollectFile_pointer);
    end

    % Get updated data with the pointer
    pszCollectFile = get(szCollectFile_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear szCollectFile_pointer;
end

