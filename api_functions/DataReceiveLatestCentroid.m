function [ fail, puFrameNumber, puElements, puFlags, pDataDest ] = DataReceiveLatestCentroid( puFrameNumber, puElements, puFlags, pDataDest )
%DATARECEIVELATESTCENTROID
% [ fail, puFrameNumber, puElements, puFlags, pDataDest ] = DataReceiveLatestCentroid( puFrameNumber, puElements, puFlags, pDataDest )
% This function receives the previously requested (using RequestLatestCentroid()) latest centroid data
% Make sure you poll this with DataIsReady(), otherwise you will corrupt data.
%   -> puFrameNumber is a counter of frames since data acquisition began
%   -> puElements is the number of markers found in the frame
%   -> puFlags is a status indiator of the Optotrak system. It's a binary mask, so if multiple flags are set, you have to de-compose the number:
%       1 (0x0001): OPTO_BUFFER_OVERRUN is undocumented, but it means that you lost data because you didn't read the buffer often enough.
%       2 (0x0002): OPTO_FRAME_OVERRUN is undocumented
%       4 (0x0004): OPTO_NO_PRE_FRAMES_FLAG is undocumented
%       8 (0x0008): OPTO_SWITCH_DATA_CHANGED_FLAG means you'll have to read out the switch data with RetrieveSwitchData()
%      16 (0x0010): OPTO_TOOL_CONFIG_CHANGED_FLAG means that the device configuration changed.
%      32 (0x0020): OPTO_FRAME_DATA_MISSED_FLAG is undocumented, but one can guess what it means :)
% If you don't use switches in your CERTUS system, don't set the OPTOTRAK_SWITCH_AND_CONFIG_FLAG during OptotrakSetupCollection(). This way, if
% puflags is non-zero, it can be used as a handy error indicator.
%   -> pDataDest is where the centroid data will be written to.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    uFrameNumber_pointer = libpointer('uint32Ptr', puFrameNumber);
    uElements_pointer = libpointer('uint32Ptr', puElements);
    uFlags_pointer = libpointer('uint32Ptr', puFlags);
    DataDest_pointer = libpointer('voidPtr', pDataDest);

    if(isunix)
        fail = calllib('liboapi', 'DataReceiveLatestCentroid', uFrameNumber_pointer, uElements_pointer, uFlags_pointer, DataDest_pointer);
    else
        if(new_or_old)
            fail = calllib('oapi64', 'DataReceiveLatestCentroid', uFrameNumber_pointer, uElements_pointer, uFlags_pointer, DataDest_pointer);
        else
            fail = calllib('oapi', 'DataReceiveLatestCentroid', uFrameNumber_pointer, uElements_pointer, uFlags_pointer, DataDest_pointer);
        end
    end
    % Get updated data with the pointer
    puFrameNumber = get(uFrameNumber_pointer, 'Value');
    puElements = get(uElements_pointer, 'Value');
    puFlags = get(uFlags_pointer, 'Value');
    pDataDest = get(DataDest_pointer, 'Value');


    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear uFrameNumber_pointer uElements_pointer uFlags_pointer DataDest_pointer;
end

