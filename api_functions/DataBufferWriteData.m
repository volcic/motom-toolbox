function [ fail, puRealTimeData, puSpoolComplete, puSpoolStatus, pulFramesBuffered ] = DataBufferWriteData( puRealTimeData, puSpoolComplete, puSpoolStatus, pulFramesBuffered )
%DATABUFFERWRITEDATA
% [ fail, puRealTimeData, puSpoolComplete, puSpoolStatus, pulFramesBuffered ] = DataBufferWriteData( puRealTimeData, puSpoolComplete, puSpoolStatus, pulFramesBuffered )
% This is the function that 'catches' data from the Optotrak,
% and it puts it to the correct destinations, which you have previously initialised using DataBufferInitializeFile() or DataBufferInitializeMem()
% WARNING: This function will toss data away if you don't initialise destinations!
%   -> puRealTimeData tells you if there is some real-time data to be received
%       0: There is no data available
% nonzero: There is data available
%   -> puSpoolComplete tells you whether the operation is completed
%       0: The operation is still in progress
% nonzero: The operation is complete
%   -> puSpoolStatus is an error indicator. It's 16 bits long, and the least significant byte contains the error type, and the upper byte contains the device ID.
%       Device IDs are:
%           0: OPTOTRAK
%           1: DATA_PROPRIETOR
%           2: ODAU1
%           3: ODAU2
%           4: ODAU3
%           5: ODAU4
%       Error codes:
%           Not sure which ones these are in the header file. Maybe a better option is OptotrakGetErrorString()?
%   -> pulFramesBuffered is the number of frames completed in the operation. This is ideal for making progress bars.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    uRealTimeData_pointer = libpointer('uint32Ptr', uint32(puRealTimeData));
    uSpoolComplete_pointer = libpointer('uint32Ptr', uint32(puSpoolComplete));
    uSpoolStatus_pointer = libpointer('uint32Ptr', uint32(puSpoolStatus));
    ulFramesBuffered_pointer = libpointer('ulongPtr', int32(pulFramesBuffered));

    if(new_or_old)
        fail = calllib('oapi64', 'DataBufferWriteData', uRealTimeData_pointer, uSpoolComplete_pointer, uSpoolStatus_pointer, ulFramesBuffered_pointer);
    else
        fail = calllib('oapi', 'DataBufferWriteData', uRealTimeData_pointer, uSpoolComplete_pointer, uSpoolStatus_pointer, ulFramesBuffered_pointer);
    end

    % Get updated data with the pointer
    puRealTimeData = get(uRealTimeData_pointer, 'Value');
    puSpoolComplete = get(uSpoolComplete_pointer, 'Value');
    puSpoolStatus = get(uSpoolComplete_pointer, 'Value');
    pulFramesBuffered = get(ulFramesBuffered_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear uRealTimeData_pointer uSpoolComplete_pointer uSpoolStatus_pointer;

end

