function [ fail, pszCollectFile ] = OdauSetupCollectionFromFile( pszCollectFile )
%ODAUSETUPCOLLECTIONFROMFILE
% [ fail, pszCollectFile ] = OdauSetupCollectionFromFile( pszCollectFile )
% This function allows you to configure your ODAU from a specified config file.
%   —> pszCollectFile is the file's name. Please don't use the extension. Standard Windows .ini systax applies:
%       [ODAU 01]
%       Parameter = value
%       ...
% Consult OdauSetupCollection.m for exact parameter description. Remove the 'n', 'f', 'p' to get the sections in the .ini file.
% Also, you can generate your own .ini file with OdauSaveCollectionToFile.m.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.


    % Prepare pointer inputs
    szCollectFile_pointer = libpointer('cstring', pszCollectFile);

    if(isunix)
        fail = calllib('liboapi', 'OdauSetupCollectionFromFile', szCollectFile_pointer);
    else
        if(new_or_old)
            fail = calllib('oapi64', 'OdauSetupCollectionFromFile', szCollectFile_pointer);
        else
            fail = calllib('oapi', 'OdauSetupCollectionFromFile', szCollectFile_pointer);
        end
    end
    % Get updated data with the pointer
    pszCollectFile = get(szCollectFile_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear szCollectFile_pointer;


end

