function [ fail, pszAutoScaleFile ] = OptotrakLoadAutoScale( pszAutoScaleFile )
%OPTOTRAKLOADAUTOSCALE This function loads the auto scale data from the specified file into the system.
%   -> pszAutoScaleFile is a file name. Do not use it with extensions, so the 'blablabla.nas' file should be called as OptotrakLoadAutoScale( 'blablabla' )
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    szAutoScaleFile_pointer = libpointer('cstring', pszAutoScaleFile);

    if(new_or_old)
        fail = calllib('oapi64', 'OptotrakLoadAutoScale', szAutoScaleFile_pointer);
    else
        fail = calllib('oapi', 'OptotrakLoadAutoScale', szAutoScaleFile_pointer);
    end

    % Get updated data with the pointer
    pszAutoScaleFile = get(szAutoScaleFile_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear szAutoScaleFile_pointer;

end

