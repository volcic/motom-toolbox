function [ fail, puElements, pDataDest6D, pDataDest3D ] = OptotrakConvertTransforms( puElements, pDataDest6D, pDataDest3D )
%OPTOTRAKCONVERTTRANSFORMS
% [ fail, puElements, pDataDest6D, pDataDest3D ] = OptotrakConvertTransforms( puElements, pDataDest6D, pDataDest3D )
% Converts a frame of 3D data to a 6D data, using the currently loaded rigid body file.
%   -> puElements is the number of rigid bodies used in the transformation
%   -> pDataDest6D is where your freshly generated data will go
%   -> pDataDest3D is the 3D coordinate array you want to do the transform on.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    uElements_pointer = libpointer('uint32Ptr', puElements);
    DataDest6D_pointer = libstruct('OptotrakRigidStruct', pDataDest6D);
    DataDest3D_pointer = libstruct('Position3D', pDataDest3D);

    if(isunix)
        fail = callib('liboapi', 'OptotrakConvertTransforms', uElements_pointer, DataDest6D_pointer, DataDest3D_pointer);
    else
        if(new_or_old)
            fail = callib('oapi64', 'OptotrakConvertTransforms', uElements_pointer, DataDest6D_pointer, DataDest3D_pointer);
        else
            fail = callib('oapi', 'OptotrakConvertTransforms', uElements_pointer, DataDest6D_pointer, DataDest3D_pointer);
        end
    end

    % Get updated data with the pointer
    puElements = get(uElements_pointer, 'Value');
    pDataDest6D = get(DataDest6D_pointer, 'Value');
    pDataDest3D = get(DataDest3D_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear uElements_pointer DataDest3D_pointer DataDest6D_pointer;
end

