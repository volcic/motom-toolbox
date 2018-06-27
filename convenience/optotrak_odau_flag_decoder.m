function [ text_flags ] = optotrak_data_flag_decoder( flag_number_as_decimal )
%OPTOTRAK_DATA_FLAG_DECODER
% [ text_flags ] = optotrak_data_flag_decoder( flag_number_as_decimal )
% This function returns a cell array with the set
%flags decoded as text. Use this function with anything ODAU related
%   -> flag_number_as_decimal is a number which will get decomposed.
%   text_flags is a cell array, with the text stuff added.
    
    text_flags{1, 1} = 'Detected flags are:';
    
    %this function is literally just a ton of IF statements.

    if(~bitand(flag_number_as_decimal, 0))
        text_flags{end + 1, 1} = 'ODAU_DIGITAL_PORT_OFF (both ports are off)';
    end
    
    if(~bitand(flag_number_as_decimal, 17))
        text_flags{end + 1, 1, 1} = 'ODAU_DIGITAL_INPB_INPA (both portS are inputs)';
    end
    
    if(~bitand(flag_number_as_decimal, 33))
        text_flags{end + 1, 1} = 'ODAU_DIGITAL_OUTPB_INPA (PORTA is output, PORTB is input)';
    end
    
    if(~bitand(flag_number_as_decimal, 34))
        text_flags{end + 1, 1} = 'ODAU_DIGITAL_OUTPB_OUTPA (both ports are outputs)';
    end

    if(~bitand(flag_number_as_decimal, 51))
        text_flags{end + 1, 1} = 'Both ports are in mixed mode';
    end

    if(~bitand(flag_number_as_decimal, 4))
        text_flags{end + 1, 1} = 'ODAU_DIGITAL_OFFB_MUXA (PORTB is off, PORTA is connected to the multiplexer)';
    end

    if(~bitand(flag_number_as_decimal, 20))
        text_flags{end + 1, 1} = 'ODAU_DIGITAL_INPB_MUXA (PORTB is input, PORTA is connected to the multiplexer)';
    end

    if(~bitand(flag_number_as_decimal, 36))
        text_flags{end + 1, 1} = 'ODAU_DIGITAL_OUTPB_MUXA (PORTB is output, PORTA is connected to the multiplexer)';
    end

end

