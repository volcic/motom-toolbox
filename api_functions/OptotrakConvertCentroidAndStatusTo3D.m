function [ fail, pElems3d, pSourceCent, pSourceStatus, pdtDataDest3D ] = OptotrakConvertCentroidAndStatusTo3D( pElems3d, pSourceCent, pSourceStatus, pdtDataDest3D )
%OPTOTRAKCONVERTCENTROIDANDSTATUSTO3D
% [ fail, pElems3d, pSourceCent, pSourceStatus, pdtDataDest3D ] = OptotrakConvertCentroidAndStatusTo3D( pElems3d, pSourceCent, pSourceStatus, pdtDataDest3D )
% This function converts centroid data to 3D data.
%   Operation is pretty much the same as OptotrakConvertFullRawTo3d( ... ), but with centroids instead of raw data.
%   -> pElems3d is the number of markers that were converted
%   -> pSourceCent is where the centroids are located
%   -> pSourceStatus is where the status is
%   -> pdtDataDest3D is where the 3D data is being written to.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    Elems3d_pointer = libpointer('uint32Ptr', pElems3d);
    SourceCent_pointer = libpointer('singlePtr', pSourceCent);
    SourceStatus_pointer = libpointer('voidPtr', pSourceStatus);
    dtDataDest3D_pointer = libstruct('Position3d', pdtDataDest3D);

    if(isunix)
        fail = calllib('liboapi', 'OptotrakConvertCentroidAndStatusTo3D', Elems3d_pointer, SourceCent_pointer, SourceStatus_pointer, dtDataDest3D_pointer);
    else
        if(new_or_old)
            fail = calllib('oapi64', 'OptotrakConvertCentroidAndStatusTo3D', Elems3d_pointer, SourceCent_pointer, SourceStatus_pointer, dtDataDest3D_pointer);
        else
            fail = calllib('oapi', 'OptotrakConvertCentroidAndStatusTo3D', Elems3d_pointer, SourceCent_pointer, SourceStatus_pointer, dtDataDest3D_pointer);
        end
    end

    % Get updated data with the pointer
    pElems3d = get(Elems3d_pointer, 'Value');
    pSourceCent = get(SourceCent_pointer, 'Value');
    pSourceStatus = get(SourceStatus_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear Elems3d_pointer SourceCent_pointer SourceStatus_pointer;
end

