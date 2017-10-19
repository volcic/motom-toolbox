function [ fail ] = blank( input_args )
%BLANK
% [ fail ] = blank( input_args ) 
% Summary of this function goes here
%   Detailed explanation goes here
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs

    if(new_or_old)
        fail = calllib('oapi64', '');
    else
        fail = calllib('oapi', );
    end

    % Get updated data with the pointer

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear 
end

