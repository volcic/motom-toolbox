function [ fail, szErrorString, nBufferSize ] = OptotrakGetErrorString( szErrorString, nBufferSize )
%OPTOTRAKGETERRORSTRING If something failed, you have a chance of reading
%the error message here.
%   -> szErrorString is the variable the string will be written to
%   -> nBufferSize is the length of the string, just in case.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    szErrorString_pointer = libpointer('cstring', szErrorString);

    if(new_or_old)
        fail = calllib('oapi64', 'OptotrakGetErrorString', szErrorString_pointer, nBufferSize);
    else
        fail = calllib('oapi', 'OptotrakGetErrorString', szErrorString_pointer, nBufferSize);
    end

    % Get updated data with the pointer
    szErrorString = get(szErrorString_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear szErrorString_pointer;
end

