function [ text_flags ] = optotrak_device_flag_decoder( flag_number_as_decimal )
%OPTOTRAK_DEVICE_FLAG_DECODER This function returns a cell array with the set
%flags decoded as text. Use this function with OptotrakGetStatus().
%   -> flag_number_as_decimal is a number which will get decomposed.
%   text_flags is a cell array, with the text stuff added.
    
    text_flags{1, 1} = 'Detected flags are:';
    
    %this function is literally just a ton of IF statements.

    if(~bitand(flag_number_as_decimal, 0))
        text_flags{end + 1, 1} = 'OPTOTRAK_BACKGROUND_SUBTRACT_OFF (undocumented)';
    end
    
    if(~bitand(flag_number_as_decimal, 1))
        text_flags{end + 1, 1, 1} = 'OPTOTRAK_NO_INTERPOLATION_FLAG (no interpolation within a frame)';
    end
    
    if(~bitand(flag_number_as_decimal, 2))
        text_flags{end + 1, 1} = 'OPTOTRAK_FULL_DATA_FLAG (when set along with OPTOTRAK_RAW_DATA_FLAG, the Optotrak system saves everything)';
    end
    
    if(~bitand(flag_number_as_decimal, 4))
        text_flags{end + 1, 1} = 'OPTOTRAK_PIXEL_DATA_FLAG (undocumented)';
    end

    if(~bitand(flag_number_as_decimal, 8))
        text_flags{end + 1, 1} = 'OPTOTRAK_MARKER_BY_MARKER_FLAG (undocumented)';
    end

    if(~bitand(flag_number_as_decimal, 16))
        text_flags{end + 1, 1} = 'OPTOTRAK_ECHO_CALIBRATE_FLAG (undocumented)';
    end

    if(~bitand(flag_number_as_decimal, 32))
        text_flags{end + 1, 1} = 'OPTOTRAK_BUFFER_RAW_FLAG (capture raw data instead of converted 3D data)';
    end

    if(~bitand(flag_number_as_decimal, 64))
        text_flags{end + 1, 1} = 'OPTOTRAK_NO_FIRE_MARKERS_FLAG (markers are not activated)';
    end
    
    if(~bitand(flag_number_as_decimal, 128))
        text_flags{end + 1, 1} = 'OPTOTRAK_STATIC_THRESHOLD_FLAG (you set the threshold value with nThreshold)';
    end

    if(~bitand(flag_number_as_decimal, 256))
        text_flags{end + 1, 1} = 'OPTOTRAK_WAVEFORM_DATA_FLAG (undocumented)';
    end

    if(~bitand(flag_number_as_decimal, 512))
        text_flags{end + 1, 1} = 'OPTOTRAK_AUTO_DUTY_CYCLE_FLAG (undocumented)';
    end

    if(~bitand(flag_number_as_decimal, 1024))
        text_flags{end + 1, 1} = 'OPTOTRAK_EXTERNAL_CLOCK_FLAG (frame rate is controlled from pin 3 of the DB9 connector)';
    end

    if(~bitand(flag_number_as_decimal, 2048))
        text_flags{end + 1, 1} = 'OPTOTRAK_EXTERNAL_TRIGGER_FLAG (data acquisition is started by pulling down pin 7 of the DB9 connector to ground)';
    end

    if(~bitand(flag_number_as_decimal, 4096))
        text_flags{end + 1, 1} = 'OPTOTRAK_REALTIME_PRESENT_FLAG (this is always 1)';
    end

    if(~bitand(flag_number_as_decimal, 8192))
        text_flags{end + 1, 1} = 'OPTOTRAK_GET_NEXT_FRAME_FLAG (the device will send the next available frame)';
    end

    if(~bitand(flag_number_as_decimal, 16384))
        text_flags{end + 1, 1} = 'OPTOTRAK_SWITCH_AND_CONFIG_FLAG (certus only: send switch data as well as position data)';
    end

    if(~bitand(flag_number_as_decimal, 32768))
        text_flags{end + 1, 1} = 'OPTOTRAK_COLPARMS_ONLY_FLAG (undocumented)';
    end

    if(~bitand(flag_number_as_decimal, 65536))
        text_flags{end + 1, 1} = 'RESERVED (undocumented)';
    end

    if(~bitand(flag_number_as_decimal, 131072))
        text_flags{end + 1, 1} = 'RESERVED (undocumented)';
    end

    if(~bitand(flag_number_as_decimal, 262144))
        text_flags{end + 1, 1} = 'RESERVED (undocumented)';
    end

    if(~bitand(flag_number_as_decimal, 524288))
        text_flags{end + 1, 1} = 'RESERVED (undocumented)';
    end

    if(~bitand(flag_number_as_decimal, 1048576))
        text_flags{end + 1, 1} = 'RESERVED (undocumented)';
    end

    if(~bitand(flag_number_as_decimal, 2097152))
        text_flags{end + 1, 1} = 'OPTOTRAK_BACKGROUND_SUBTRACT_ON (undocumented)';
    end

    if(~bitand(flag_number_as_decimal, 4194301))
        text_flags{end + 1, 1} = 'RESERVED (undocumented)';
    end

    if(~bitand(flag_number_as_decimal, 8388608))
        text_flags{end + 1, 1} = 'RESERVED (undocumented)';
    end

    if(~bitand(flag_number_as_decimal, 16777216))
        text_flags{end + 1, 1} = 'Undocumented';
    end

    if(~bitand(flag_number_as_decimal, 33554432))
        text_flags{end + 1, 1} = 'OPTOTRAK_CERTUS_FLAG (if this is set, you have a Certus system)';
    end

    if(~bitand(flag_number_as_decimal, 67108864))
        text_flags{end + 1, 1} = 'OPTOTRAK_RIGID_CAPABLE_FLAG';
    end

    if(~bitand(flag_number_as_decimal, 134217728))
        text_flags{end + 1, 1} = 'RESERVED (undocumented)';
    end

    if(~bitand(flag_number_as_decimal, 268435456))
        text_flags{end + 1, 1} = 'RESERVED (undocumented)';
    end

    if(~bitand(flag_number_as_decimal, 536870912))
        text_flags{end + 1, 1} = 'OPTOTRAK_CERTUS_FLAG and OPTOTRAK_REVISION_X22_FLAG (set by the Optotrak system itself)';
    end

    if(~bitand(flag_number_as_decimal, 1076741824))
        text_flags{end + 1, 1} = 'OPTOTRAK_3020_FLAG (if this is set, you have the 3020 strobers)';
    end
end

