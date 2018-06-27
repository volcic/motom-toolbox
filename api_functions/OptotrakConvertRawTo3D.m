function [ fail, puElements, pSensorReadings, pdt3DPositions ] = OptotrakConvertRawTo3D( puElements, pSensorReadings, pdt3DPositions )
%OPTOTRAKCONVERTRAWTO3D
% [ fail, pElems3d, pElems6d, pSrcFullRaw, pDst3d, pdtDataDest6d ] = OptotrakConvertFullRawTo6D( pElems3d, pElems6d, pSrcFullRaw, pDst3d, pdtDataDest6d )
% Converts the camera's raw data to actual 3D
%coordinates.
%   -> puElements is the number of converted markers
%   -> pSensorReadings is the frame of the raw data
%   -> pdt3Dpositions is the coordinate array this function will fill up
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    uElements_pointer = libpointer('uint32Ptr', puElements);
    SensorReadings_pointer = libpointer('voidPtr', pSensorReadings);
    dt3DPositions_pointer = libstruct('Position3D', pdt3DPositions);

    if(isunix)
        fail = callib('liboapi', 'OptotrakConvertRawTo3D', uElements_pointer, SensorReadings_pointer, dt3DPositions_pointer);
    else
        if(new_or_old)
            fail = callib('oapi64', 'OptotrakConvertRawTo3D', uElements_pointer, SensorReadings_pointer, dt3DPositions_pointer);
        else
            fail = callib('oapi', 'OptotrakConvertRawTo3D', uElements_pointer, SensorReadings_pointer, dt3DPositions_pointer);
        end
    end

    % Get updated data with the pointer

    puElements = get(uElements_pointer, 'Value');
    pSensorReadings = get(SensorReadings_pointer, 'Value');
    pdt3DPositions = get(dt3DPositions_pointer, 'Value');
    
    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear uElements_pointer SensorReadings_pointer dt3DPositions_pointer;
end

