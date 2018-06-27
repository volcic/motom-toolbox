function [ fail, nMarkerType, nWaveLength, nModelType ] = OptotrakSetCameraParameters( nMarkerType, nWaveLength, nModelType )
%OPTOTRAKSETCAMERAPARAMETERS
% [ fail, nMarkerType, nWaveLength, nModelType ] = OptotrakSetCameraParameters( nMarkerType, nWaveLength, nModelType )
% This function allows you to change the marker type, its wavelength, and the camera lens model.
%   -> nMarkerType:
%       1: Metal markers (default)
%       2: Ceramic markers
%       3: Unknown :)
%   -> nWaveLength:
%       0: 950 nm (default)
%       1: 880 nm
%   -> nModelType:
%       0: Original lens (default)
%       1: 'new' lens
%       2: 'new new' lens (wider angles)
%       3: PRO CMM
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    if(isunix)
        fail = calllib('liboapi', 'OptotrakSetCameraParameters', nMarkerType, nWaveLength, nModelType);
    else
        if(new_or_old)
            fail = calllib('oapi64', 'OptotrakSetCameraParameters', nMarkerType, nWaveLength, nModelType);
        else
            fail = calllib('oapi', 'OptotrakSetCameraParameters', nMarkerType, nWaveLength, nModelType);
        end
    end
end

