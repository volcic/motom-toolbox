function [ fail, nOdauId, pnChannels, pnGain, pnDigitalMode, pfFrameFrequency, pfScanFrequency, pnStreamData, pfCollectionTime, pfPreTriggerTime, puCollFlags, pnFlags ] = OdauGetStatus( nOdauId, pnChannels, pnGain, pnDigitalMode, pfFrameFrequency, pfScanFrequency, pnStreamData, pfCollectionTime, pfPreTriggerTime, puCollFlags, pnFlags )
%ODAUGETSTATUS
% [ fail, nOdauId, pnChannels, pnGain, pnDigitalMode, pfFrameFrequency, pfScanFrequency, pnStreamData, pfCollectionTime, pfPreTriggerTime, puCollFlags, pnFlags ] = OdauGetStatus( nOdauId, pnChannels, pnGain, pnDigitalMode, pfFrameFrequency, pfScanFrequency, pnStreamData, pfCollectionTime, pfPreTriggerTime, puCollFlags, pnFlags )
% This function gets all the information available for a selected ODAU device.
% You can adjust these settings with OdauSetupCollection(...) and/or OdauSetupCollectionFromFile(...)
%   -> nOdauId select which ODAU is being queried. It's a binary mask, and the decimal values correspond to:
%       2: ODAU1
%       3: ODAU2
%       4: ODAU3
%       5: ODAU4
%   (these listed variables are pointers, and the function writes into them)
%   -> pnChannels is the number of channels
%   -> pnGain is the gain for the analogue channels
%   -> pnDigitalMode is the digital ports' operation, as follows:
%           0 (0x00): ODAU_DIGITAL_PORT_OFF is pretty self-explanatory
%          17 (0x11): ODAU_DIGITAL_INPB_INPA means that both ports are inputs
%          33 (0x21): ODAU_DIGITAL_OUTPB_INPA means that PORTB is output, and PORTA is inptut
%          34 (0x22): ODAU_DIGITAL_OUTPB_OUTPA means that both ports are outputs
%          51 (0x33): Both ports are in mixed mode. No info about this in the header file.
%           4 (0x04): ODAU_DIGITAL_OFFB_MUXA means that PORTB is off, and PORTA is connected internally to the muliplexer
%          20 (0x14): ODAU_DIGITAL_INPB_MUXA means that PORTB is input, and PORTA is connected to the multiplexer
%          36 (0x24): ODAU_DIGITAL_OUTPB_MUXA means that PORTB is output, and PORTA is connected to the multiplexer
%   -> pfFrameFrequency is the frame rate
%   -> pfScanFrequency is the frequency the inputs are being sampled at within a frame
%   -> pnStreamData tells whether the ODAU is continuously streaming data, or holds it in its buffer until you read it out
%       0: the ODAU is holding the data until you read out the buffer
%       1: the ODAU is streaming data automatically
%   -> pfCollectionTime is the time it took to collect the data in the buffer
%   -> pfPreTriggerTime is unimplemented, and is always 0.
%   -> puCollFlags tells you how the analogue inputs are configured:
%       0: All voltages are recorded with respect to the ground (aka unbalanced)
%       1: ODAU_DIFFERENTIAL_FLAG means that the voltages were recorded differentially (aka balanced)
%   -> pnFlags are the values the ODAU was initialised with. It's a binary mask, so the numbers are added if multiple flags are set.
%       (Neither the manual, nor the header file goes into details on how these are organised.)
%
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    nChannels_pointer = libpointer('int32Ptr', pnChannels);
    nGain_pointer = libpointer('int32Ptr', pnGain);
    nDigitalMode_pointer = libpointer('int32Ptr', pnDigitalMode);
    fFrameFrequency_pointer = libpointer('singlePtr', pfFrameFrequency);
    fScanFrequency_pointer = libpointer('singlePtr', pfScanFrequency);
    nStreamData_pointer = libpointer('int32Ptr', pnStreamData);
    fCollectionTime_pointer = libpointer('singlePtr', pfCollectionTime);
    fPreTriggerTime_pointer = libpointer('singlePtr', pfPreTriggerTime);
    uCollFlags_pointer = libpointer('uint32Ptr', puCollFlags);
    nFlags_pointer = libpointer('int32Ptr', pnFlags);

    if(isunix)
        fail = calllib('liboapi', 'OdauGetStatus', nOdauId, nChannels_pointer, nGain_pointer, nDigitalMode_pointer, fFrameFrequency_pointer, fScanFrequency_pointer, nStreamData_pointer, fCollectionTime_pointer, fPreTriggerTime_pointer, uCollFlags_pointer, nFlags_pointer);
    else
        if(new_or_old)
            fail = calllib('oapi64', 'OdauGetStatus', nOdauId, nChannels_pointer, nGain_pointer, nDigitalMode_pointer, fFrameFrequency_pointer, fScanFrequency_pointer, nStreamData_pointer, fCollectionTime_pointer, fPreTriggerTime_pointer, uCollFlags_pointer, nFlags_pointer);
        else
            fail = calllib('oapi', 'OdauGetStatus', nOdauId, nChannels_pointer, nGain_pointer, nDigitalMode_pointer, fFrameFrequency_pointer, fScanFrequency_pointer, nStreamData_pointer, fCollectionTime_pointer, fPreTriggerTime_pointer, uCollFlags_pointer, nFlags_pointer);
        end
    end
    % Get updated data with the pointer
    pnChannels = get(nChannels_pointer, 'Value');
    pnGain = get(nGain_pointer, 'Value');
    pnDigitalMode = get(nDigitalMode_pointer, 'Value');
    pfFrameFrequency = get(fFrameFrequency_pointer, 'Value');
    pfScanFrequency = get(fScanFrequency_pointer, 'Value');
    pnStreamData = get(nStreamData_pointer, 'Value');
    pfCollectionTime = get(fCollectionTime_pointer, 'Value');
    pfPreTriggerTime = get(fPreTriggerTime_pointer, 'Value');
    puCollFlags = get(uCollFlags_pointer, 'Value');
    pnFlags = get(nFlags_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear nChannels_pointer nGain_pointer nDigitalMode_pointer fFrameFrequency_pointer fScanFrequency_pointer nStreamData_pointer fCollectionTime_pointer fPreTriggerTime_pointer uCollFlags_pointer nFlags_pointer;
end

