function [ fail, nMarkers, nSensors, pDataSourceFullRaw, pCentroids, pSensorsStatus ] = OptotrakSplitFullRaw( nMarkers, nSensors, pDataSourceFullRaw, pCentroids, pSensorsStatus )
%OPTOTRAKSPLITFULLRAW
% [ fail, nMarkers, nSensors, pDataSourceFullRaw, pCentroids, pSensorsStatus ] = OptotrakSplitFullRaw( nMarkers, nSensors, pDataSourceFullRaw, pCentroids, pSensorsStatus )
% This function splits the full raw data to centroids and statuses.
%   -> nMarkers is the number of markers found in the raw data
%   -> nSensors is the number of sensors used to capture the raw data
%   -> pDataSourceFullRaw is one frame of full raw data to be processed
%   -> pCentroids is where the centroid data will be saved to
%   -> pSensorsStatus is where the sensor status information will go
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    DataSourceFullRaw_pointer = libpointer('voidPtr', pDataSourceFullRaw);
    Centroids_pointer = libpointer('voidPtr', pCentroids);
    SensorsStatus_pointer = libpointer('voidPtr', pSensorsStatus);

    if(isunix)
        fail = calllib('liboapi', 'OptotrakSplitFullRaw', nMarkers, nSensors, DataSourceFullRaw_pointer, Centroids_pointer, SensorsStatus_pointer);
    else
        if(new_or_old)
            fail = calllib('oapi64', 'OptotrakSplitFullRaw', nMarkers, nSensors, DataSourceFullRaw_pointer, Centroids_pointer, SensorsStatus_pointer);
        else
            fail = calllib('oapi', 'OptotrakSplitFullRaw', nMarkers, nSensors, DataSourceFullRaw_pointer, Centroids_pointer, SensorsStatus_pointer);
        end
    end

    % Get updated data with the pointer
    pDataSourceFullRaw = get(DataSourceFullRaw_pointer, 'Value');
    pCentroids = get(Centroids_pointer, 'Value');
    pSensorsStatus = get(SensorsStatus_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear DataSourceFullRaw_pointer Centroids_pointer SensorsStatus_pointer;
end

