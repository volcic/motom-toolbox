function [ fail, puFrameNumber, puElements, puFlags, pDataDest6d, pDataDest3d ] = DataGetLatestTransforms2( puFrameNumber, puElements, puFlags, pDataDest6d, pDataDest3d )
%DATAGETLATESTTRANSFORMS2 This function obtains both the 3D and 6D rigid body transforms that has been captured.
%   -> puFrameNumber is a counter of frames since data acquisition began
%   -> puElements is the number of ridid body transforms found in the frame
%   -> puFlags is a status indiator of the Optotrak system. It's a binary mask, so if multiple flags are set, you have to de-compose the number:
%       1 (0x0001): OPTO_BUFFER_OVERRUN is undocumented, but it means that you lost data because you didn't read the buffer often enough, or it didn't fit to its buffer.
%       2 (0x0002): OPTO_FRAME_OVERRUN is undocumented
%       4 (0x0004): OPTO_NO_PRE_FRAMES_FLAG is undocumented
%       8 (0x0008): OPTO_SWITCH_DATA_CHANGED_FLAG means you'll have to read out the switch data with RetrieveSwitchData()
%      16 (0x0010): OPTO_TOOL_CONFIG_CHANGED_FLAG means that the device configuration changed.
%      32 (0x0020): OPTO_FRAME_DATA_MISSED_FLAG is undocumented, but one can guess what it means :)
% If you don't use switches in your CERTUS system, don't set the OPTOTRAK_SWITCH_AND_CONFIG_FLAG during OptotrakSetupCollection(). This way, if
% puFlags is non-zero, it can be used as a handy error indicator.
%   -> pDataDest6d is where the calculated ridid bodies will be stored to
%   -> pDataDest3D is where the calculated X-Y-Z coordinates will be saved to
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    %Prepare pointer inputs
    uFrameNumber_pointer = libpointer('uint32Ptr', puFrameNumber);
    uElements_pointer = libpointer('uint32Ptr', puElements);
    uFlags_pointer = libpointer('uint32Ptr', puFlags);
    DataDest6d_pointer = libstruct('OptotrakRigidStruct', pDataDest6d);
    DataDest3d_pointer = libpointer('Position3d', pDataDest3d);

    if(new_or_old)
        fail = calllib('oapi64', 'DataGetLatestTransforms2', uFrameNumber_pointer, uElements_pointer, uFlags_pointer, DataDest6d_pointer, DataDest3d_pointer);
    else
        fail = calllib('oapi', 'DataGetLatestTransforms2', uFrameNumber_pointer, uElements_pointer, uFlags_pointer, DataDest6d_pointer, DataDest3d_pointer);
    end

    % Get updated data with the pointer
    puFrameNumber = get(uFrameNumber_pointer, 'Value');
    puElements = get(uElements_pointer, 'Value');
    puFlags = get(uFlags_pointer, 'Value');
    pDataDest6d = recover_structure_array(DataDest6d_pointer, puElements); %this will be a structure array.
    pDataDest3d = recover_structure_array(DataDest3d_pointer, puElements); %this will be a structure array.

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear uFrameNumber_pointer uElements_pointer uFlags_pointer DataDest6d_pointer DataDest3d_pointer;
end

