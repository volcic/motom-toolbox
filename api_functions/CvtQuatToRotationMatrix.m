function [ fail, pdtQuatRot, pdtRotMatrix ] = CvtQuatToRotationMatrix( pdtQuatRot, pdtRotMatrix )
%CVTQUATTOROTATIONMATRIX 
% [ fail, pdtQuatRot, pdtRotMatrix ] = CvtQuatToRotationMatrix( pdtQuatRot, pdtRotMatrix )
% This function converts a quaternion matrix to a rotation matrix
% Do not use structure arrays in this, execute for each marker!
%   -> pdtQuatRot is the quaternion matrix to be converted
%   -> pdtRotMatrix is the output of this function, 3-by-3 elements
%   fail is the return value of the function. Since the function is initialised as void type, I gave it a constant 0.
%   You have to manually check whether the function failed, by inspecting the output values.
    % Prepare pointer inputs
    dtQuatRot_pointer = libpointer('QuatRotationStructPtr', pdtQuatRot);
    %pdtRotMatrix is not a pointer.

    if(new_or_old)
        calllib('oapi64', 'CvtQuatToRotationMatrix', dtQuatRot_pointer, pdtRotMatrix);
    else
        calllib('oapi', 'CvtQuatToRotationMatrix', dtQuatRot_pointer, pdtRotMatrix);
    end

    % Get updated data with the pointer
    pdtQuatRot = get(dtQuatRot_pointer, 'Value');
    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear dtQuatRot_pointer;

    fail = 0;
end

