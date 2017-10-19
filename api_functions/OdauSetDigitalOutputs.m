function [ fail, nOdauId, puDigitalOut, uUpdateMask ] = OdauSetDigitalOutputs( nOdauId, puDigitalOut, uUpdateMask )
%ODAUSETDIGITALOUTPUTS
% [ fail, nOdauId, puDigitalOut, uUpdateMask ] = OdauSetDigitalOutputs( nOdauId, puDigitalOut, uUpdateMask )
% This function allows you to se the digital outputs on the ODAU box.
% The two ports are controlled in a single 8-bit word. The four most significant bits are PORTB, and the four least significant bits are PORTA
% However, note that when you actually get data from the ODAU, this byte will be in the most significant half of a 16-bit word.
%   -> nOdauId is the ODAU selected, as follows:
%       2: ODAU1
%       3: ODAU2
%       4: ODAU3
%       5: ODAU4
%   -> puDigitalOut is the byte word with the two ports' bits in.
%   -> uUpdateMask allows you to specify which bits are configured as output (0) or input (1)
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    uDigitalOut_pointer = libpointer('uint32Ptr', puDigitalOut);

    if(new_or_old)
        fail = calllib('oapi64', 'OdauSetDigitalOutputs', nOdauId, uDigitalOut_pointer, uUpdateMask);
    else
        fail = calllib('oapi', 'OdauSetDigitalOutputs', nOdauId, uDigitalOut_pointer, uUpdateMask);
    end

    % Get updated data with the pointer
    puDigitalOut = get(uDigitalOut_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear uDigitalOut_pointer;
end

