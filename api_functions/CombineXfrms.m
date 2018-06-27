function [fail, pdtXfrm1, pdtXfrm2, pdtNewXfrm] = CombineXfrms(pdtXfrm1, pdtXfrm2, pdtNewXfrm)
%COMBINEXFRMS 
% fail, pdtXfrm1, pdtXfrm2, pdtNewXfrm] = CombineXfrms(pdtXfrm1, pdtXfrm2, pdtNewXfrm)
% Combine two Euler angle transformations into one.
%   —> pdtXfrm1 First Euler angle Transform
%   -> pdtXfrm2 Second Euler angle transform
%   —> pdtNewXfrm is where the result goes.
% Note that this function has no return value so there is no way to find out if it crashes, apart from checking the transformed values themselves.

    % Prepare pointer inputs
    dtXfrm1_pointer = libstruct('transformation', pdtXfrm1);
    dtXfrm2_pointer = libstruct('transformation', pdtXfrm2);
    dtNewXfrm_pointer = libstruct('transformation', pdtNewXfrm);
 
    if(isunix)
        fail = calllib('liboapi', 'CombineXfrms', dtXfrm1_pointer, dtXfrm2_pointer, dtNewXfrm_pointer);
    else
    
        if(new_or_old())
            calllib('oapi64', 'CombineXfrms', dtXfrm1_pointer, dtXfrm2_pointer, dtNewXfrm_pointer);
        else
            calllib('oapi', 'CombineXfrms', dtXfrm1_pointer, dtXfrm2_pointer, dtNewXfrm_pointer);
        end
    end

    % Get updated data with the pointer
    pdtXfrm1 = get(dtXfrm1_pointer);
    pdtXfrm2 = get(dtXfrm2_pointer);
    pdtNewXfrm = get(dtNewXfrm_pointer);
    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear dtXfrm1_pointer dtXfrm2_pointer dtNewXfrm_pointer;

    fail = 0;

end

