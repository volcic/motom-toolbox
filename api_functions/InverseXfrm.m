function [ fail, pdtXfrm, pdtInverseXfrm ] = InverseXfrm( pdtXfrm, pdtInverseXfrm )
%INVERSEXFRM
% [ fail, pdtXfrm, pdtInverseXfrm ] = InverseXfrm( pdtXfrm, pdtInverseXfrm )
% This function calculates the inverse Euler angles.
%   -> pdtXfrm is the input
%   -> pdtInverseXfrm is the output
%   fail is the return value of the function. Since the function is initialised as void type, I gave it a constant 0.
% You have to manually inspect whether the function failed, by checking the output values for example.

    % Prepare pointer inputs
    dtXfrm_pointer = libpointer('structure', pdtXfrm);
    dtInverseXfrm_pointer = libpointer('structure', pdtInverseXfrm);

    if(isunix)
        fail = calllib('liboapi', 'InverseXfrm', dtXfrm_pointer, dtInverseXfrm_pointer);
    else
        if(new_or_old)
            fail = calllib('oapi64', 'InverseXfrm', dtXfrm_pointer, dtInverseXfrm_pointer);
        else
            fail = calllib('oapi', 'InverseXfrm', dtXfrm_pointer, dtInverseXfrm_pointer);
        end
    end

    % Get updated data with the pointer
    pdtXfrm = get(dtXfrm_pointer, 'Value');
    pdtInverseXfrm = get(dtXfrm_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear dtXfrm_pointer dtInverseXfrm_pointer;
    fail = 0;
end

