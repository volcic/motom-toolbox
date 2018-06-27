function [ fail, uFileId, lnStartFrame, uNumberofFrames, pDataSrc ] = FileWrite( uFileId, lnStartFrame, uNumberofFrames, pDataSrc )
%FILEWRITE
% [ fail, uFileId, lnStartFrame, uNumberofFrames, pDataSrc ] = FileWrite( uFileId, lnStartFrame, uNumberofFrames, pDataSrc )
% writes the floating point data data to the specified file
%   -> uFileId is the file indentifier you assigned when you opened the file with either FileOpen() or FileOpenAll()
%   -> lnStartFrame is a frame offset. If you want to write your buffer out from the beginning of the file, set this to 0.
%   -> uNumberofFrames tells the function how many frames are to be written out. You should know how long your file is.
%   -> pDataSrc is the data you want to write out to the opened file.
% Important: This function only saves the floating point data, and make sure that the number of frames written out correspond to what is in the file header. Nothing does this sanity check later-on in the processing chain.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    DataSrc_pointer = libpointer('voidPtr', pDataSrc);

    if(isunix)
        fail = calllib('liboapi', 'FileWrite', uFileId, lnStartFrame, uNumberofFrames, DataSrc_pointer);
    else
        if(new_or_old)
            fail = calllib('oapi64', 'FileWrite', uFileId, lnStartFrame, uNumberofFrames, DataSrc_pointer);
        else
            fail = calllib('oapi', 'FileWrite', uFileId, lnStartFrame, uNumberofFrames, DataSrc_pointer);
        end
    end

    % Get updated data with the pointer
    pDataSrc = get(DataSrc_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear DataSrc_pointer;
end

