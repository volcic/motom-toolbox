function [ fail, pnNumSensors, pnNumOdaus, pnNumRigidBodies, pnMarkers, pfFrameFrequency, pfMarkerFrequency, pnThreshold, pnMinimumGain, pnStreamData, pfDutyCycle, pfVoltage, pfCollectionTime, pfPreTriggerTime, pnFlags ] = OptotrakGetStatus( pnNumSensors, pnNumOdaus, pnNumRigidBodies, pnMarkers, pfFrameFrequency, pfMarkerFrequency, pnThreshold, pnMinimumGain, pnStreamData, pfDutyCycle, pfVoltage, pfCollectionTime, pfPreTriggerTime, pnFlags )
%OPTOTRAKGETSTATUS
% [ fail, pnNumSensors, pnNumOdaus, pnNumRigidBodies, pnMarkers, pfFrameFrequency, pfMarkerFrequency, pnThreshold, pnMinimumGain, pnStreamData, pfDutyCycle, pfVoltage, pfCollectionTime, pfPreTriggerTime, pnFlags ] = OptotrakGetStatus( pnNumSensors, pnNumOdaus, pnNumRigidBodies, pnMarkers, pfFrameFrequency, pfMarkerFrequency, pnThreshold, pnMinimumGain, pnStreamData, pfDutyCycle, pfVoltage, pfCollectionTime, pfPreTriggerTime, pnFlags )
% Queries the system for status.
%   -> pnNumSensors is the number of sensors in use.
%   -> pnNumOdaus is the number of ODAUs in the system
%   -> pnNumRigidBodies is the number of rigid bodies in the system
%   -> pnMarkers is the number of markers currently used in the system
%   -> pfFrameFrequency is the current data acquisition rate
%   -> pfMarkerFrequency is the frequency the IR LEDs are being strobed at
%   -> pnThreshold is the threshold value in pixels used for processing
%   -> pnMinimumGain is the minimum sensor gain used.
%   -> pnStreamData: 0 for buffered data when requested, or 1, for automatically blasting data
%   -> pfDutyCycle is the duty cycle used on the IR LEDs
%   -> pfVoltage is the voltage the IR LEDs are driven at
%   -> pfCollectionTime is the length in seconds for buffered data
%   -> pfPreTriggerTime: not implemented, and is always 0.
%   -> pnFlags is a binary mask. In Matlab, this is a single number, so if you want to read this, you'll need to de-compose it as follows:
%              0 (0x00000000): Clear all flags (also, OPTOTRAK_BACKGROUND_SUBTRACT_OFF), but it's undocumented
%              1 (0x00000001): OPTOTRAK_NO_INTERPOLATION_FLAG: When set, the position is not being interpolated within a frame.
%              2 (0x00000002): OPTOTRAK_FULL_DATA_FLAG: When set along with OPTOTRAK_BUFFER_RAW_FLAG, the device captures everything
%              4 (0x00000004): OPTOTRAK_PIXEL_DATA_FLAG: Undocumented
%              8 (0x00000008): OPTOTRAK_MARKER_BY_MARKER_FLAG: Undocumented
%             16 (0x00000010): OPTOTRAK_ECHO_CALIBRATE_FLAG: Undocumented
%             32 (0x00000020): OPTOTRAK_BUFFER_RAW_FLAG: Acquire the raw data instead of the 3D data.
%             64 (0x00000040): OPTOTRAK_NO_FIRE_MARKERS_FLAG: If this is set, the markers don't become active when this function is called. Call OptotrakActivateMarkers() to switch them on.
%            128 (0x00000080): OPTOTRAK_STATIC_THRESHOLD_FLAG: Use the static thresholds, set in nThreshold.
%            256 (0x00000100): OPTOTRAK_WAVEFORM_DATA_FLAG: Undocumented
%            512 (0x00000200): OPTOTRAK_AUTO_DUTY_CYCLE_FLAG: Undocumented. Presumably NDI wanted to control the brightness of the IR LEDs from within the system.
%           1024 (0x00000400): OPTOTRAK_EXTERNAL_CLOCK_FLAG: The capture frame rate can be from Pin 3 on the DB9 connector, using a TTL signal. Handy.
%           2048 (0x00000800): OPTOTRAK_EXTERNAL_TRIGGER_FLAG: Once this function executed, data acquisition only starts when pin 7 on the DB9 connector is pulled to ground.
%           4096 (0x00001000): OPTOTRAK_REALTIME_PRESENT_FLAG: Don't use it. Always 1.
%           8192 (0x00002000): OPTOTRAK_GET_NEXT_FRAME_FLAG: If this is set, the device will send the next frame instead of the current one. Prevents duplicates.
%          16384 (0x00004000): OPTOTRAK_SWITCH_AND_CONFIG_FLAG: If set, switch data is being set back to the computer. Only works with the Certus system.
%          32768 (0x00008000): OPTOTRAK_COLPARMS_ONLY_FLAG: Undocumented
%          65536 (0x00010000): Undocumented (reserved)
%         131072 (0x00020000): Undocumented (reserved)
%         262144 (0x00040000): Undocumented (reserved)
%         524288 (0x00080000): Undocumented (reserved)
%        1048576 (0x00100000): Undocumented (reserved)
%        2097152 (0x00200000): OPTOTRAK_BACKGROUND_SUBTRACT_ON: Undocumented
%        4194301 (0x00800000): Undocumented (reserved)
%        8388608 (0x01000000): Undocumented (reserved)
%       16777216 (0x02000000): ??? (it's not even in the header file)
%       33554432 (0x04000000): OPTOTRAK_CERTUS_FLAG (set by the Optotrak system itself)
%       67108864 (0x08000000): OPTOTRAK_RIGID_CAPABLE_FLAG (set by the Optotrak system itself)
%      134217728 (0x10000000): Undocumented (reserved)
%      268435456 (0x20000000): Undocumented (reserved)
%      536870912 (0x40000000): OPTOTRAK_CERTUS_FLAG and OPTOTRAK_REVISION_X22_FLAG (set by the Optotrak system itself)
%     1076741824 (0x80000000): OPTOTRAK_3020_FLAG (set by the Optotrak system itself)
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    nNumSensors_pointer = libpointer('int32Ptr', pnNumSensors);
    nNumOdaus_pointer = libpointer('int32Ptr', pnNumOdaus);
    nNumRigidBodies_pointer = libpointer('int32Ptr', pnNumRigidBodies);
    nMarkers_pointer = libpointer('int32Ptr', pnMarkers);
    fFrameFrequency_pointer = libpointer('singlePtr', pfFrameFrequency);
    fMarkerFrequency_pointer = libpointer('singlePtr', pfMarkerFrequency);
    nThreshold_pointer = libpointer('int32Ptr', pnThreshold);
    nMinimumGain_pointer = libpointer('int32Ptr', pnMinimumGain);
    nStreamData_pointer = libpointer('int32Ptr', pnStreamData);
    fDutyCycle_pointer = libpointer('singlePtr', pfDutyCycle);
    fVoltage_pointer = libpointer('singlePtr', pfVoltage);
    fCollectionTime_pointer = libpointer('singlePtr', pfCollectionTime);
    fPreTriggerTime_pointer = libpointer('singlePtr', pfPreTriggerTime);
    nFlags_pointer = libpointer('int32Ptr', pnFlags);


    if(isunix)
        fail = calllib('liboapi', 'OptotrakGetStatus', nNumSensors_pointer, nNumOdaus_pointer, nNumRigidBodies_pointer, nMarkers_pointer, fFrameFrequency_pointer, fMarkerFrequency_pointer, nThreshold_pointer, nMinimumGain_pointer, nStreamData_pointer, fDutyCycle_pointer, fVoltage_pointer, fCollectionTime_pointer, fPreTriggerTime_pointer, nFlags_pointer);
    else
        if(new_or_old)
            fail = calllib('oapi64', 'OptotrakGetStatus', nNumSensors_pointer, nNumOdaus_pointer, nNumRigidBodies_pointer, nMarkers_pointer, fFrameFrequency_pointer, fMarkerFrequency_pointer, nThreshold_pointer, nMinimumGain_pointer, nStreamData_pointer, fDutyCycle_pointer, fVoltage_pointer, fCollectionTime_pointer, fPreTriggerTime_pointer, nFlags_pointer);
        else
            fail = calllib('oapi', 'OptotrakGetStatus', nNumSensors_pointer, nNumOdaus_pointer, nNumRigidBodies_pointer, nMarkers_pointer, fFrameFrequency_pointer, fMarkerFrequency_pointer, nThreshold_pointer, nMinimumGain_pointer, nStreamData_pointer, fDutyCycle_pointer, fVoltage_pointer, fCollectionTime_pointer, fPreTriggerTime_pointer, nFlags_pointer);
        end
    end

    % Get updated data with the pointer
    pnNumSensors = get(nNumSensors_pointer, 'Value');
    pnNumOdaus = get(nNumOdaus_pointer, 'Value');
    pnNumRigidBodies = get(nNumRigidBodies_pointer, 'Value');
    pnMarkers = get(nMarkers_pointer, 'Value');
    pfFrameFrequency = get(fFrameFrequency_pointer, 'Value');
    pfMarkerFrequency = get(fMarkerFrequency_pointer, 'Value');
    pnThreshold = get(nThreshold_pointer, 'Value');
    pnMinimumGain = get(nMinimumGain_pointer, 'Value');
    pnStreamData = get(nStreamData_pointer, 'Value');
    pfDutyCycle = get(fDutyCycle_pointer, 'Value');
    pfVoltage = get(fVoltage_pointer, 'Value');
    pfCollectionTime = get(fCollectionTime_pointer, 'Value');
    pfPreTriggerTime = get(fPreTriggerTime_pointer, 'Value');
    pnFlags = get(nFlags_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear nNumSensors_pointer nNumOdaus_pointer nNumRigidBodies_pointer nMarkers_pointer fFrameFrequency_pointer fMarkerFrequency_pointer nThreshold_pointer nMinimumGain_pointer nStreamData_pointer fDutyCycle_pointer fVoltage_pointer fCollectionTime_pointer fPreTriggerTime_pointer nFlags_pointer;
end