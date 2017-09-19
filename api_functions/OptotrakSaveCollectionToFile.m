function [ fail, pszCollectFile ] = OptotrakSaveCollectionToFile( pszCollectFile )
%OPTOTRAKSAVECOLLECTIONTOFILE Saves your settings to a config file specified
% This allows you to edit the file manually, and read it with OptotrakReadCollectionFromFile().
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    szCollectFile_pointer = libpointer('cstring', pszCollectFile);

    if(new_or_old)
        fail = calllib('oapi64', 'OptotrakSaveCollectionToFile', szCollectFile_pointer);
    else
        fail = calllib('oapi', 'OptotrakSaveCollectionToFile', szCollectFile_pointer);
    end

    % Get updated data with the pointer
    pszCollectFile = get(szCollectFile_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear szCollectFile_pointer;
end

