function [ fail, nNodeId, nSubNodeId, pdtNodeInfo ] = OptotrakGetSubNodeInfo( nNodeId, nSubNodeId, pdtNodeInfo )
%OPTOTRAKGETSUBNODEINFO This function gets information from sub-nodes into the system.
% Since NDI is obsessed with this weird transputer architecture, here is some explanation on what happens:
% Back in the day, the idea was that the 'control box' was a node, and the connected sensors and strobers to it was a 'sub-node'.
% However, just like any other company, they just bolted-on extra features to the old stuff to sell it as more expensive new stuff,
% so now the the SCU also has some sub-nodes that were integrated.
% -> nNodeId is the main node ID.
%       0: OPTOTRAK node
%       1: Undocumented (ODAU1?)
%       2: Undocumented (ODAU2?)
%       3: Undocumented (ODAU3?)
%       4: Undocumented (ODAU4?)
%       5: Undocumented (ODAU5?)
%       6: SENSOR_PROP1 node
%   -> nSubNodeId is the sub-node ID for a given node:
%       For the OPTOTRAK node:
%        299: CPLD (Complex Programmable Logic Device)
%        399: FPGA (Field-Programmable Gate Array)
%        499: 'Default FPGA'
%        599: Cypress (which is I presume is the wireless controller) 
%       For the SENSOR_PROP1 node (i.e. camera):
%        0: Sensor 0
%        1: Sensor 1
%        2: Sensor 2
%        3: Sensor 3
%       Note that the Certus system has only 3 sensors. The PRO CMM has 4.
%   -> pdtNodeInfo is the structure being written into
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    dtNodeInfo_pointer = libstruct('OptoNodeInfoStruct', pdtNodeInfo);

    if(new_or_old)
        fail = calllib('oapi64', 'OptotrakGetSubNodeInfo', nNodeId, nSubNodeId, dtNodeInfo_pointer);
    else
        fail = calllib('oapi', 'OptotrakGetSubNodeInfo', nNodeId, nSubNodeId, dtNodeInfo_pointer);
    end

    % Get updated data with the pointer
    pdtNodeInfo = get(dtNodeInfo_pointer);

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear dtNodeInfo_pointer;
end

