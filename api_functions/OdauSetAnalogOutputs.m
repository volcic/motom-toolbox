function [ fail, nOdauId, pfVoltage1, pfVoltage2, uChangeMask ] = OdauSetAnalogOutputs( nOdauId, pfVoltage1, pfVoltage2, uChangeMask )
%ODAUSETANALOGOUTPUTS this functions sets the voltages of the two analogue outputs of the ODAU.
% The voltage range is between +5 and -5 Volts.
%   -> nOdauId is the ODAU selected, as follows:
%       2: ODAU1
%       3: ODAU2
%       4: ODAU3
%       5: ODAU4
%   -> pfVoltage1 is the voltage value for analogue output channel 1
%   -> pfVoltage2 is the voltage value for analogue output channel 2
%   uChangeMask allows you to select what happens with the channels
%       0: If you set this to 0, then you can read out the current voltage values on both channels.
%       1: Channel 1 is being updated, channel 2 is unchanged.
%       2: Channel 2 is being updated, channel 1 is unchanged.
%       3: Update both channels
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    fVoltage1_pointer = libpointer('singlePtr', pfVoltage1);
    fVoltage2_pointer = libpointer('singlePtr', pfVoltage2);

    if(new_or_old)
        fail = calllib('oapi64', 'OdauSetAnalogOutputs', fVoltage1_pointer, fVoltage2_pointer);
    else
        fail = calllib('oapi', 'OdauSetAnalogOutputs', fVoltage1_pointer, fVoltage2_pointer);
    end

    % Get updated data with the pointer
    pfVoltage1 = get(fVoltage1_pointer, 'Value');
    pfVoltage2 = get(fVoltage2_pointer, 'Value');


    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear fVoltage1_pointer fVoltage2_pointer;
end

