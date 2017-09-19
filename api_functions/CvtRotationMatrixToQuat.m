function [ fail, pdtQuatRot, pdtRotMatrix ] = CvtRotationMatrixToQuat( pdtQuatRot, pdtRotMatrix )
%CVTROTATIONMATRIXTOQUAT This function converts a rotation matrix to quaternion format
% Do not use structure arrays in this, execute for each marker!
%   -> pdtQuatRot is where the results will go in quaternion format
%   -> pdtRotMatrix is the input rotation matrix data, 3-by-3 elements.
%   fail is the return value of the function. Since the function is initialised as void type, I gave it a constant 0.
% You have to manually inspect whether the function failed, by checking the output values for example.

    % Prepare pointer inputs
    dtQuatRot_pointer = libpointer('QuatRotationStructPtr', pdtQuatRot);
    %pdtRotMatrix is not a pointer.

    if(new_or_old)
        calllib('oapi64', 'CvtRotationMatrixToQuat', dtQuatRot_pointer, pdtRotMatrix);
    else
        calllib('oapi', 'CvtRotationMatrixToQuat', dtQuatRot_pointer, pdtRotMatrix);
    end

    % Get updated data with the pointer
    pdtQuatRot = get(dtQuatRot_pointer, 'Value');
    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear dtQuatRot_pointer;

    fail = 0;

end

