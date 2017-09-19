function [ fail, pszInputFileName, pszOutputFileName, uFileType ] = FileConvert( pszInputFileName, pszOutputFileName, uFileType )
%FILECONVERT This function converts raw data to the NDI file format, as follows:
% Optotrak raw data will be converted to 3D positions.
% ODAU raw data will be converted to voltages.
% Make sure that the file is not being opened by anything else at the same time.
%   -> pszInputFileName is the file's name to be converted.
%   -> pszOutputFileName is where the converted file will be saved at.
%   -> uFileType is a binary mask:
%       1: OPTOTRAK_RAW tells the function that the input file is a raw camera file.
%       2: ANALOG_RAW tells the function that the input file is ODAU waveform data.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    szInputFileName_pointer = libpointer('cstring', pszInputFileName);
    szOutputFileName_pointer = libpointer('cstring', pszOutputFileName);

    if(new_or_old)
        fail = calllib('oapi64', 'FileConvert', szInputFileName_pointer, szOutputFileName_pointer, uFileType);
    else
        fail = calllib('oapi', 'FileConvert', szInputFileName_pointer, szOutputFileName_pointer, uFileType);
    end

    % Get updated data with the pointer
    pszInputFileName = get(szInputFileName_pointer, 'Value');
    pszOutputFileName = get(szOutputFileName_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear szInputFileName_pointer szOutputFileName_pointer;
end

