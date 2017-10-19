function [ fail, pElems3d, pElems6d, pSourceCent, pSourceStatus, pdtDataDest3d, pdtDataDest6d ] = OptotrakConvertCentroidAndStatusTo6D( pElems3d, pElems6d, pSourceCent, pSourceStatus, pdtDataDest3d, pdtDataDest6d )
%OPTOTRAKCONVERTCENTROIDANDSTATUSTO6D
% [ fail, pElems3d, pElems6d, pSourceCent, pSourceStatus, pdtDataDest3d, pdtDataDest6d ] = OptotrakConvertCentroidAndStatusTo6D( pElems3d, pElems6d, pSourceCent, pSourceStatus, pdtDataDest3d, pdtDataDest6d )
% This function converts a previously captured centroid data frame into 3D and 6D positions, using the ridid body definitions
%   -> pElems3d is the number of markers used in the caputre.
%   -> pElems6d is the number of rigid bodies used in the conversion
%   -> pSourceCent is the source centroids in the previously caputred frame.
%   -> pSourceStatus is the status (the manual is not very talkative on what this actually is on page 100)
%   -> pdtDataDest3d is where the 3D coordinates go
%   -> pdtDataDest6d is where rigid body stuff goes
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    Elems3d_pointer = libpointer('uint32Ptr', pElems3d);
    Elems6d_pointer = libpointer('uint32Ptr', pElems6d);
    SourceCent_pointer = libpointer('singlePtr', pSourceCent);
    SourceStatus_pointer = libpointer('voidPtr', pSourceStatus);
    dtDataDest3d_pointer = libstruct('Position3D', pdtDataDest3d);
    dtDataDest6d_pointer = libstruct('OptotrakRigidStrct', pdtDataDest6d);


    if(new_or_old)
        fail = calllib('oapi64', 'OptotrakConvertCentroidAndStatusTo6D', Elems3d_pointer, Elems6d_pointer, SourceCent_pointer, SourceStatus_pointer, dtDataDest3d_pointer, dtDataDest6d_pointer);
    else
        fail = calllib('oapi', 'OptotrakConvertCentroidAndStatusTo6D', Elems3d_pointer, Elems6d_pointer, SourceCent_pointer, SourceStatus_pointer, dtDataDest3d_pointer, dtDataDest6d_pointer);
    end

    % Get updated data with the pointer
    pElems3d = get(Elems3d_pointer, 'Value');
    pElems6d = get(Elems6d_pointer, 'Value');
    pSourceCent = get(SourceCent_pointer, 'Value');
    pSourceStatus = get(SourceStatus_pointer, 'Value');
    pdtDataDest3d = get(dtDataDest3d_pointer, 'Value');
    pdtDataDest6d = get(dtDataDest6d_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear Elems3d_pointer Elems6d_pointer SourceCent_pointer SourceStatus_pointer dtDataDest3d_pointer dtDataDest6d_pointer;
end

