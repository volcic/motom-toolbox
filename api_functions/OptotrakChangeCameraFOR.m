function [ fail, pszInputCamFile, nNumMarkers, pdtMeasuredPositions, pdtAlignedPositions, pszAlignedCamFile, pdt3dErrors, pfRmsError] = OptotrakChangeCameraFOR( pszInputCamFile, nNumMarkers, pdtMeasuredPositions, pdtAlignedPositions, pszAlignedCamFile, pdt3dErrors, pfRmsError )
%OPTOTRAKCHANGECAMERAFOR
% [ fail, pszInputCamFile, nNumMarkers, pdtMeasuredPositions, pdtAlignedPositions, pszAlignedCamFile, pdt3dErrors, pfRmsError] = OptotrakChangeCameraFOR( pszInputCamFile, nNumMarkers, pdtMeasuredPositions, pdtAlignedPositions, pszAlignedCamFile, pdt3dErrors, pfRmsError )
% Alters the camera's coordinate system. Input
%arguments are:
%   -> pszInputCamFile is the name of the camera file. If this is a zero
%   length string, it will load 'standard.cam'.
%   -> nNumMarkers is the number of markers used.
%   -> pdtAlignedPositions Coordinates in the desired coordinate system
%   -> pdtMeasuredPositions Coordinates stored in the current coordinate system
%   -> pszAlignedCamFile The name of the new camera file
%   -> pdt3dErrors Transforming the alignment introduces errors, this is where they go.
%   -> pfRmsError RMS distance errors from the transformation go here.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    szInputCamFile_pointer = libpointer('cstring', pszInputCamFile);
    szAlignedCamFile_pointer = libpointer('cstring', pszAlignedCamFile);

    if(new_or_old)
        fail = calllib('oapi64', 'OptotrakChangeCameraFOR', szInputCamFile_pointer, nNumMarkers, pdtMeasuredPositions, pdtAlignedPositions, szAlignedCamFile_pointer, pdt3dErrors, pfRmsError);
    else
        fail = calllib('oapi', 'OptotrakChangeCameraFOR', szInputCamFile_pointer, nNumMarkers, pdtMeasuredPositions, pdtAlignedPositions, szAlignedCamFile_pointer, pdt3dErrors, pfRmsError);
    end

    % Get updated data with the pointer
    pszInputCamFile = get(szInputCamFile_pointer, 'Value');
    pszAlignedCamFile = get(szAlignedCamFile_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear szInputCamFile_pointer szAlignedCamFile_pointer;

end

