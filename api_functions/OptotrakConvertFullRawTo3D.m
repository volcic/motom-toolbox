function [ fail, pElems3d, pDataSourceFullRaw, pdtDataDest3d ] = OptotrakConvertFullRawTo3D( pElems3d, pDataSourceFullRaw, pdtDataDest3d )
%OPTOTRAKCONVERTFULLRAWTO3D This functions converts a previously captured single frame's full raw data to 3D positions.
%   -> pElems3d is the number of markers that were converted.
%   -> pDataSourceFullRaw is the source of the single frame full raw data
%   -> pdtDataDest3d is the destination Position3D structure the positions are being written into
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs

    Elems3d_pointer = libpointer('uint32Ptr', pElems3d);
    DataSourceFullRaw_pointer = libpointer('voidPtr', pDataSourceFullRaw);
    dtDataDest3d_pointer = libstruct('Position3D', pdtDataDest3d);

    if(new_or_old)
        fail = calllib('oapi64', 'OptotrakConvertFullRawTo3D', Elems3d_pointer, DataSourceFullRaw_pointer, dtDataDest3d_pointer);
    else
        fail = calllib('oapi', 'OptotrakConvertFullRawTo3D', Elems3d_pointer, DataSourceFullRaw_pointer, dtDataDest3d_pointer);
    end

    % Get updated data with the pointer
    pElems3d = get(Elems3d_pointer, 'Value');
    pDataSourceFullRaw = get(DataSourceFullRaw_pointer, 'Value');
    pdtDataDest3d = get(dtDataDest3d_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear Elems3d_pointer DataSourceFullRaw_pointer dtDataDest3d_pointer;
end

