function [ fail, nMarkers, fFrameFrequency, fMarkerFrequency, nThreshold, nMinimumGain, nStreamData, fDutyCycle, fVoltage, fCollectionTime, fPreTriggerTime, nFlags ] = OptotrakSetupCollection( nMarkers, fFrameFrequency, fMarkerFrequency, nThreshold, nMinimumGain, nStreamData, fDutyCycle, fVoltage, fCollectionTime, fPreTriggerTime, nFlags )
%OPTOTRAKSETUPCOLLECTION This function configures the Optotrak system using the parameters you specify here.
%   Sets up the Optotrak system for data collection.
%   -> nMarkers is the number of markers to be used
%   -> fFrameFrequency is the data acquisition frame rate (lowest is 1, max is 4600 / [<number of markers> + 2] )
%   -> fMarkerFrequency is the frequency the markers are driven at
%   -> nThreshold is the noise threshold for the marker positions in sensor pixels. Can be adjusted statically (0...3000) or dynamically (0...3000)
%   -> nMinimumGain is the gain to be applied on the sensor. (0...255)
%   -> nStreamData decides whether the buffer is to be read out periodically or manually
%       0: You are reading out the buffer manually
%       1: The device sends the contents of the buffer automatically.
%   -> fDutyCycle is the duty cycle the IR LEDs are turned on (0.1...0.85)
%   -> fVoltage is the voltage the IR LEDs are being driven at (6.0....12.0)
%
%   WARNING: DO NOT OVERDRIVE THE IR LEDS! YOU WILL DAMAGE THEM!!!!
%   (rule of thumb: the duty cycle and the driving voltages are inversely proportional)
%
%   -> fCollectionTime is the time the Optotrak records movement, in seconds (0, 99999), up to about 1600 hours.
%   -> fPreTriggerTime is not implemented and has to be 0.
%   -> nFlags is a binary mask. In Matlab, they are represented as binary numbers, so if you want to trigger multiple flags, just add their numbers:
%              0 (0x00000000): Clear all flags (also, OPTOTRAK_BACKGROUND_SUBTRACT_OFF), but it's undocumented
%              1 (0x00000001): OPTOTRAK_NO_INTERPOLATION_FLAG: When set, the position is not being interpolated within a frame.
%              2 (0x00000002): OPTOTRAK_FULL_DATA_FLAG: When set along with OPTOTRAK_BUFFER_RAW_FLAG, the device returns raw data
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
%           
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs

    if(new_or_old)
        fail = calllib('oapi64', 'OptotrakSetupCollection', nMarkers, fFrameFrequency, fMarkerFrequency, nThreshold, nMinimumGain, nStreamData, fDutyCycle, fVoltage, fCollectionTime, fPreTriggerTime, nFlags);
    else
        fail = calllib('oapi', 'OptotrakSetupCollection', nMarkers, fFrameFrequency, fMarkerFrequency, nThreshold, nMinimumGain, nStreamData, fDutyCycle, fVoltage, fCollectionTime, fPreTriggerTime, nFlags);
    end

end