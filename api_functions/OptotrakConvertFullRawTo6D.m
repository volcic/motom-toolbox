function [ fail, pElems3d, pElems6d, pSrcFullRaw, pDst3d, pdtDataDest6d ] = OptotrakConvertFullRawTo6D( pElems3d, pElems6d, pSrcFullRaw, pDst3d, pdtDataDest6d )
%OPTOTRAKCONVERTFULLRAWTO6D This function converts a previously captured full raw data frame into 3D and 6D positions, using the ridid body definitions
%   -> pElems3d is the number of markers that were converted
%   -> pElems6d is the number of rigid bodies that were converted
%   -> pSrcFullRaw is the source of a single frame's worth of full raw data
%   -> pDst3d is a structure where the 3D data is being saved to
%   -> pdtDataDest6d is a structure where the 6D ridid body data is being saved to.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    Elems3d_pointer = libpointer('uint32Ptr', pElems3d);
    Elems6d_pointer = libpointer('uint32Ptr', pElems6d);
    SrcFullRaw_pointer = libpointer('voidPtr', pSrcFullRaw);
    Dst3d_pointer = libstruct('Position3D', pDst3d);
    dtDataDest6d_pointer = libstruct('OptotrakRigidStruct', pdtDataDest6d);

    if(new_or_old)
        fail = calllib('oapi64', 'OptotrakConvertFullRawTo6D', Elems3d_pointer, Elems6d_pointer, SrcFullRaw_pointer, Dst3d_pointer, dtDataDest6d_pointer);
    else
        fail = calllib('oapi', 'OptotrakConvertFullRawTo6D', Elems3d_pointer, Elems6d_pointer, SrcFullRaw_pointer, Dst3d_pointer, dtDataDest6d_pointer);
    end

    % Get updated data with the pointer
    pElems3d = get(Elems3d_pointer, 'Value');
    pElems6d = get(Elems6d_pointer, 'Value');
    pSrcFullRaw = get(SrcFullRaw_pointer, 'Value');
    pDst3d = get(Dst3d_pointer, 'Value');
    pdtDataDest6d = get(dtDataDest6d_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear Elems3d_pointer Elems6d_pointer SrcFullRaw_pointer Dst3d_pointer dtDataDest6d_pointer;

end

