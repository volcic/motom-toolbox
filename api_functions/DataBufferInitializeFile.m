function [uDataId, pszFileName] = DataBufferInitializeFile(uDataId, pszFileName)
%DATABUFFERINITIALIZEFILE
% [uDataId, pszFileName] = DataBufferInitializeFile(uDataId, pszFileName)
% ... is the function that opens the file where the
%data will be saved. Contrary to what is written in the API manual, make sure that the file doesn't exist before calling this function. Otherwise, the system will hang at optotrak_stop_buffering_and_write_out().
%   -> uDataId is the device identifier, as follows:
%       0: OPTOTRAK
%       1: DATA_PROPRIETOR, but this wasn't in the manual
%       2: ODAU1
%       3: ODAU2
%       4: ODAU3
%       5: ODAU4
%   pszFileName is the file name with path.

    % Prepare pointer inputs
    szFileName_pointer = libpointer('cstring', pszFileName);

    if(new_or_old())
        [pszFileName] = calllib('oapi64', 'DataBufferInitializeFile', uDataId, szFileName_pointer);
    else
        [pszFileName] = calllib('oapi', 'DataBufferInitializeFile', uDataId, szFileName_pointer);
    end

    % Get updated data with the pointer
    pszFileName = get(szFileName_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear szFileName_pointer;

end