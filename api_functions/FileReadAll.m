function [ fail, uFileId, lnStartFrame, uNumberofFrames, pDataDestFloat, pDataDestChar, pDataDestInt, pDataDestDouble ] = FileReadAll( uFileId, lnStartFrame, uNumberofFrames, pDataDestFloat, pDataDestChar, pDataDestInt, pDataDestDouble )
%FILEREADALL
% [ fail, uFileId, lnStartFrame, uNumberofFrames, pDataDestFloat, pDataDestChar, pDataDestInt, pDataDestDouble ] = FileReadAll( uFileId, lnStartFrame, uNumberofFrames, pDataDestFloat, pDataDestChar, pDataDestInt, pDataDestDouble )
% This function reads every type of data from the specified file
%   -> uFileId is the file indentifier you assigned when you opened the file with either FileOpen() or FileOpenAll()
%   -> lnStartFrame is a frame offset. If you want to read from the beginning of the file, set this to 0.
%   -> uNumberofFrames tells the function how many frames are to be read. You should know how long your file is, by calling FileOpen() or FileOpenAll()
%   -> pDataDestFloat is where the floating point data gets saved to.
%   -> pDataDestChar is where the character data gets saved to.
%   -> pDataDestInt is where the integer data gets saved to.
%   -> pDataDestDouble is where the double data gets saved to.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    DataDestFloat_pointer = libpointer('voidPtr', pDataDestFloat);
    DataDestChar_pointer = libpointer('voidPtr', pDataDestChar);
    DataDestInt_pointer = libpointer('voidPtr', pDataDestInt);
    DataDestDouble_pointer = libpointer('voidPtr', pDataDestDouble);

    if(new_or_old)
        fail = calllib('oapi64', 'FileRead', uFileId, lnStartFrame, uNumberofFrames, DataDestFloat_pointer, DataDestChar_pointer, DataDestInt_pointer, DataDestDouble_pointer);
    else
        fail = calllib('oapi', 'FileRead', uFileId, lnStartFrame, uNumberofFrames, DataDestFloat_pointer, DataDestChar_pointer, DataDestInt_pointer, DataDestDouble_pointer);
    end

    % Get updated data with the pointer
    pDataDestFloat = get(DataDestFloat_pointer, 'Value');
    pDataDestChar = get(DataDestChar_pointer, 'Value');
    pDataDestInt = get(DataDestInt_pointer, 'Value');
    pDataDestDouble = get(DataDestDouble_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear DataDestFloat_pointer DataDestChar_pointer DataDestInt_pointer DataDestDouble_pointer;

end

