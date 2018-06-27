function [ fail, pdtRotMatrix, pdtEulerRot ] = DetermineEuler( pdtRotMatrix, pdtEulerRot )
%DETERMINEEULER
% [ fail, pdtRotMatrix, pdtEulerRot ] = DetermineEuler( pdtRotMatrix, pdtEulerRot )
% This function calculates the Euler angles from the provided rotation matrix.
%   -> pdtRotMatrix is the input, a 3-by-3 element matrix
%   -> pftEulerRot is the output
%   fail is the return value of the function. Since Since the function is initialised as void type, I gave it a constant 0.
% You have to manually inspect whether the function failed, by checking the output values for example.

    % Prepare pointer inputs
    %pdtRotMatrix is not a pointer.
    dtEulerRot_poiner = libpointer('structure', pdtEulerRot);

    if(isunix)
        calllib('liboapi', 'DetermineEuler', pdtRotMatrix, dtEulerRot_poiner);
    else
        if(new_or_old)
            calllib('oapi64', 'DetermineEuler', pdtRotMatrix, dtEulerRot_poiner);
        else
            calllib('oapi', 'DetermineEuler', pdtRotMatrix, dtEulerRot_poiner);
        end
    end
    % Get updated data with the pointer
    pdtEulerRot = get(dtEulerRot_poiner, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear dtEulerRot_poiner;

    fail = 0;

end

