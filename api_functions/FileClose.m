function [ fail, uFileId ] = FileClose( uFileId )
%FILECLOSE
% [ fail, uFileId ] = FileClose( uFileId )
% This function closes the data file that has been previously opened by the API.
%   -> uFileId is the id FileOpen() gave the file you opened programmatically.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    if(isunix)
        fail = calllib('liboapi', 'FileClose', uFileId);
    else
        if(new_or_old)
            fail = calllib('oapi64', 'FileClose', uFileId);
        else
            fail = calllib('oapi', 'FileClose', uFileId);
        end
    end
end

