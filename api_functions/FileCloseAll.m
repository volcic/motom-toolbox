function [ fail, uFileId ] = FileCloseAll( uFileId )
%FILECLOSEALL
% [ fail, uFileId ] = FileCloseAll( uFileId )
% This function closes the data files that has been previously opened by the API.
% Note that this function is only for things you opened with FileOpenAll().
%   -> uFileId is the id FileOpenAll() gave the file you opened programmatically.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.


    if(new_or_old)
        fail = calllib('oapi64', 'FileCloseAll', uFileId);
    else
        fail = calllib('oapi', 'FileCloseAll', uFileId);
    end

end

