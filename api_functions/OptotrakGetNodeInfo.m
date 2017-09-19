function [ fail, nNodeId, pdtNodeInfo ] = OptotrakGetNodeInfo( nNodeId, pdtNodeInfo )
%OPTOTRAKGETNODEINFO Returns information of any node determined by the
%nNodeId in the system
%   -> nNodeId can be six values, listed below
%   -> pdtNodeInfo is the structure the data is being written into
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.
% Node Ids:
%   0 for Optotrak
%   1 for 'Data proprietor'
%   2 for ODAU1
%   3 for ODAU2
%   4 for ODAU3
%   5 for ODAU4
%   6 for SENSOR_PROP1

    % Prepare pointer inputs
    dtNodeInfo_pointer = libstruct('OptoNodeInfoStruct', pdtNodeInfo);
    if(new_or_old)
        fail = calllib('oapi64', 'OptotrakGetNodeInfo', nNodeId, dtNodeInfo_pointer);
    else
        fail = calllib('oapi', 'OptotrakGetNodeInfo', nNodeId, dtNodeInfo_pointer);
    end
    % Get updated data with the pointer
    pdtNodeInfo = get(dtNodeInfo_pointer);

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear dtNodeInfo_pointer;
end

