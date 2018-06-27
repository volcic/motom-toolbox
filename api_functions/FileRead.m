function [ fail, uFileId, lnStartFrame, uNumberofFrames, pDataDest ] = FileRead( uFileId, lnStartFrame, uNumberofFrames, pDataDest )
%FILEREAD
% [ fail, uFileId, lnStartFrame, uNumberofFrames, pDataDest ] = FileRead( uFileId, lnStartFrame, uNumberofFrames, pDataDest )
% Reads the floating point data data from the specified file
%   -> uFileId is the file indentifier you assigned when you opened the file with either FileOpen() or FileOpenAll()
%   -> lnStartFrame is a frame offset. If you want to read from the beginning of the file, set this to 0.
%   -> uNumberofFrames tells the function how many frames are to be read. You should know how long your file is, by calling FileOpen() or FileOpenAll()
%   -> pDataDest is where the read-out contents go in the memory.
% Important: This function only accesses the floating point data.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    DataDest_pointer = libpointer('voidPtr', pDataDest);

    if(isunix)
        fail = calllib('liboapi', 'FileRead', uFileId, lnStartFrame, uNumberofFrames, DataDest_pointer);
    else
        if(new_or_old)
            fail = calllib('oapi64', 'FileRead', uFileId, lnStartFrame, uNumberofFrames, DataDest_pointer);
        else
            fail = calllib('oapi', 'FileRead', uFileId, lnStartFrame, uNumberofFrames, DataDest_pointer);
        end
    end

    % Get updated data with the pointer
    pDataDest = get(DataDest_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear DataDest_pointer;
end

