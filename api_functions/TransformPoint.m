function [ fail, pdtRotationMatrix, pdtTranslation, pdtOriginalPositionPtr, pdtTransformedPositionPtr ] = TransformPoint( pdtRotationMatrix, pdtTranslation, pdtOriginalPositionPtr, pdtTransformedPositionPtr )
%TRANSFORMPOINT
% [ fail, pdtRotationMatrix, pdtTranslation, pdtOriginalPositionPtr, pdtTransformedPositionPtr ] = TransformPoint( pdtRotationMatrix, pdtTranslation, pdtOriginalPositionPtr, pdtTransformedPositionPtr )
% This function calculates the 3D x-y-z point of a point, after it has been manipulated by translation and rotation.
%   -> pdtRotationMatrix is the 3-by-3 matrix that contains the rotation data
%   -> pdtTranslation has the translation structure
%   -> pdtOriginalPositionPtr is your point's X-Y-Z data
%   -> pdtTransformedPositionPtr is where the new coordinates go
%   fail is the return value of the function. Since the function is initialised as void type, I gave it a constant 0.
% You have to manually inspect whether the function failed, by checking the output values for example.


    % Prepare pointer inputs
    %pdtRotationMatrix is not a pointer.
    dtTranslation_pointer = libpointer('Position3d', pdtTranslation);
    dtOriginalPositionPtr_pointer = libpointer('Position3d', pdtOriginalPositionPtr);
    dtTransformedPositionPtr_pointer = libpointer('Position3d', pdtTransformedPositionPtr);

    if(new_or_old)
        calllib('oapi64', 'TransformPoint', pdtRotationMatrix, dtTranslation_pointer, dtOriginalPositionPtr_pointer, dtTransformedPositionPtr_pointer);
    else
        calllib('oapi', 'TransformPoint', pdtRotationMatrix, dtTranslation_pointer, dtOriginalPositionPtr_pointer, dtTransformedPositionPtr_pointer);
    end

    % Get updated data with the pointer
    pdtTranslation = get(dtTranslation_pointer, 'Value');
    pdtOriginalPositionPtr = get(dtOriginalPositionPtr_pointer, 'Value');
    pdtTransformedPositionPtr = get(dtTransformedPositionPtr_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear dtTranslation_pointer dtOriginalPositionPtr_pointer dtTransformedPositionPtr_pointer;

end

