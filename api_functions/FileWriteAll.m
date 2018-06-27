function [ fail, uFileId, lnStartFrame, uNumberofFrames, pDataSrcFloat, pDataSrcChar, pDataSrcInt, pDataSrcDouble ] = FileWriteAll( uFileId, lnStartFrame, uNumberofFrames, pDataSrcFloat, pDataSrcChar, pDataSrcInt, pDataSrcDouble )
%FILEWRITEALL
% [ fail, uFileId, lnStartFrame, uNumberofFrames, pDataSrcFloat, pDataSrcChar, pDataSrcInt, pDataSrcDouble ] = FileWriteAll( uFileId, lnStartFrame, uNumberofFrames, pDataSrcFloat, pDataSrcChar, pDataSrcInt, pDataSrcDouble )
% This function writes out every type of data to the specified file
%   -> uFileId is the file indentifier you assigned when you opened the file with either FileOpen() or FileOpenAll()
%   -> lnStartFrame is a frame offset. If you want to write out from the beginning your data, set this to 0.
%   -> uNumberofFrames tells the function how many frames are to be written out. You should already know how many frames are there in your data.
%   -> pDataSrcFloat is where the floating point data gets read out from.
%   -> pDataSrcChar is where the character data gets read out from.
%   -> pDataSrcInt is where the integer data gets read out from.
%   -> pDataSrcDouble is where the double data gets read out from.
% Important: Make sure that the number of data items written out correspond to what is in the file header. Nothing does this sanity check later-on in the processing chain.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    DataSrcFloat_pointer = libpointer('voidPtr', pDataSrcFloat);
    DataSrcChar_pointer = libpointer('voidPtr', pDataSrcChar);
    DataSrcInt_pointer = libpointer('voidPtr', pDataSrcInt);
    DataSrcDouble_pointer = libpointer('voidPtr', pDataSrcDouble);

    if(isunix)
        fail = calllib('liboapi', 'FileWriteAll', uFileId, lnStartFrame, uNumberofFrames, DataSrcFloat_pointer, DataSrcChar_pointer, DataSrcInt_pointer, DataSrcDouble_pointer);
    else
        if(new_or_old)
            fail = calllib('oapi64', 'FileWriteAll', uFileId, lnStartFrame, uNumberofFrames, DataSrcFloat_pointer, DataSrcChar_pointer, DataSrcInt_pointer, DataSrcDouble_pointer);
        else
            fail = calllib('oapi', 'FileWriteAll', uFileId, lnStartFrame, uNumberofFrames, DataSrcFloat_pointer, DataSrcChar_pointer, DataSrcInt_pointer, DataSrcDouble_pointer);
        end
    end
    % Get updated data with the pointer
    pDataSrcFloat = get(DataSrcFloat_pointer, 'Value');
    pDataSrcChar = get(DataSrcChar_pointer, 'Value');
    pDataSrcInt = get(DataSrcInt_pointer, 'Value');
    pDataSrcDouble = get(DataSrcDouble_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear DataSrcFloat_pointer DataSrcChar_pointer DataSrcInt_pointer DataSrcDouble_pointer;
end

