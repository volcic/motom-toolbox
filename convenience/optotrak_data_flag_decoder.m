function [ text_flags ] = optotrak_data_flag_decoder( flag_number_as_decimal )
%OPTOTRAK_DATA_FLAG_DECODER
% [ text_flags ] = optotrak_data_flag_decoder( flag_number_as_decimal )
% This function returns a cell array with the set flags decoded as text. Use this function with anything that handles data.
%   -> flag_number_as_decimal is a number which will get decomposed.
%   text_flags is a cell array, with the text stuff added.
    
    if(verLessThan('matlab', '8.1'))
        warning('You seem to use a Matlab version older than R2013a. Flag decoding will not work properly.')
    end


    text_flags{1, 1} = 'Detected flags are:';
    
    %this function is literally just a ton of IF statements.

    if(~bitand(flag_number_as_decimal, 0))
        text_flags{end + 1, 1} = 'No flags set';
    end
    
    if(~bitand(flag_number_as_decimal, 1))
        text_flags{end + 1, 1, 1} = 'OPTO_BUFFER_OVERRUN (you lost data)';
    end
    
    if(~bitand(flag_number_as_decimal, 2))
        text_flags{end + 1, 1} = 'OPTO_FRAME_OVERRUN (undocumented)';
    end
    
    if(~bitand(flag_number_as_decimal, 4))
        text_flags{end + 1, 1} = 'OPTO_NO_PRE_FRAMES_FLAG (undocumented)';
    end

    if(~bitand(flag_number_as_decimal, 8))
        text_flags{end + 1, 1} = 'OPTO_SWITCH_DATA_CHANGED_FLAG (you have some new data available, and can read it out)';
    end

    if(~bitand(flag_number_as_decimal, 16))
        text_flags{end + 1, 1} = 'OPTO_TOOL_CONFIG_CHANGED_FLAG (the device configuration changed after being initialised)';
    end

    if(~bitand(flag_number_as_decimal, 32))
        text_flags{end + 1, 1} = 'OPTO_FRAME_DATA_MISSED_FLAG (undocumented)';
    end

end

