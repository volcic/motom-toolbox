function [ fail, pdtEulerRot, pdtRotMatrix ] = DetermineR( pdtEulerRot, pdtRotMatrix )
%DETERMINER
% [ fail, pdtEulerRot, pdtRotMatrix ] = DetermineR( pdtEulerRot, pdtRotMatrix )
% This function calulates the rotations from Euler angles.
%   -> pdtEulerRot is the input Euler angles
%   -> pdtRotMatrix is the output 3-by-3 rotation matrix
%   fail is the return value of the function. Since the function is initialised as void type, I gave it a constant 0.
% You have to manually inspect whether the function failed, by checking the output values for example.

    % Prepare pointer inputs
    dtEulerRot_pointer = libstruct('QuatRotationStruct', pdtEulerRot);
    %pdtRotMatrix is not a pointer.

    if(isunix)
        calllib('liboapi', 'DetermineR', dtEulerRot_pointer, pdtRotMatrix);
    else
        if(new_or_old)
            calllib('oapi64', 'DetermineR', dtEulerRot_pointer, pdtRotMatrix);
        else
            calllib('oapi', 'DetermineR', dtEulerRot_pointer, pdtRotMatrix);
        end
    end
    
    % Get updated data with the pointer
    pdtEulerRot = get(dtEulerRot_pointer);

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear dtEulerRot_pointer;
    fail = 0;
end

