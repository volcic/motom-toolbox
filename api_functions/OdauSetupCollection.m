function [ fail, nOdauId, nChannels, nGain, nDigitalMode, fFrameFrequency, fScanFrequency, nStreamData, fCollectionTime, fPreTriggerTime, uFlags ] = OdauSetupCollection( nOdauId, nChannels, nGain, nDigitalMode, fFrameFrequency, fScanFrequency, nStreamData, fCollectionTime, fPreTriggerTime, uFlags )
%ODAUSETUPCOLLECTION
% [ fail, nOdauId, nChannels, nGain, nDigitalMode, fFrameFrequency, fScanFrequency, nStreamData, fCollectionTime, fPreTriggerTime, uFlags ] = OdauSetupCollection( nOdauId, nChannels, nGain, nDigitalMode, fFrameFrequency, fScanFrequency, nStreamData, fCollectionTime, fPreTriggerTime, uFlags )
% This function configures the ODAU for data acquisition.
%   -> nOdauId is the ODAU selected, as follows:
%       2: ODAU1
%       3: ODAU2
%       4: ODAU3
%       5: ODAU4
%   -> nChannels is the number of channels to record from. Can select between 1 and 256.
%   -> nGain controls the settings of the built-in amplifier. With the different settings, the voltage range is:
%       1: +/- 10V (gain = 1)
%       5: +/- 2V (gain = 5)
%      10: +/- 1V (gain = 10)
%     100: +/- 100mV (gain = 100)
% Note that the gain is only adjustable to these discrete values.
%   -> pnDigitalMode is the digital ports' operation, as follows:
%           0 (0x00): ODAU_DIGITAL_PORT_OFF is pretty self-explanatory
%          17 (0x11): ODAU_DIGITAL_INPB_INPA means that both ports are inputs
%          33 (0x21): ODAU_DIGITAL_OUTPB_INPA means that PORTB is output, and PORTA is inptut
%          34 (0x22): ODAU_DIGITAL_OUTPB_OUTPA means that both ports are outputs
%          51 (0x33): Both ports are in mixed mode. No info about this in the header file.
%           4 (0x04): ODAU_DIGITAL_OFFB_MUXA means that PORTB is off, and PORTA is connected internally to the muliplexer
%          20 (0x14): ODAU_DIGITAL_INPB_MUXA means that PORTB is input, and PORTA is connected to the multiplexer
%          36 (0x24): ODAU_DIGITAL_OUTPB_MUXA means that PORTB is output, and PORTA is connected to the multiplexer
% A useful feature is that the output ports can be read as inputs, and you can recover the previously sent out bit combination.
%   -> fFrameFrequency is the frequency the ODAU samples all the channels, to collect a frame of data. Ranges between 1 and 100000
%   -> fScanFrequency is the rate which the channels are being scanned within a frame. Ranges between 1 and 100000
% Note that the higher gain you use, the lower your scan frequency can be.
%   -> nStreamData tells the ODAU to:
%       0: Keep the data in the buffer until you read it out
%       1: Stream the collected data continuously
%   -> fCollectionTime tells the ODAU how many seconds of data to collect when using the buffer. Values can be between 1 and 99999.
%   -> fPreTriggerTime is not implemented and it 'must' be 0.
%   -> uFlags specifies how the analogue channes should be handled:
%       0: All voltages are recorded with respect to the ground (aka unbalanced)
%       1: ODAU_DIFFERENTIAL_FLAG means that the voltages were recorded differentially (aka balanced)
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    if(isunix)
        fail = calllib('liboapi', 'OdauSetupCollection', nOdauId, nChannels, nGain, nDigitalMode, fFrameFrequency, fScanFrequency, nStreamData, fCollectionTime, fPreTriggerTime, uFlags);
    else
        if(new_or_old)
            fail = calllib('oapi64', 'OdauSetupCollection', nOdauId, nChannels, nGain, nDigitalMode, fFrameFrequency, fScanFrequency, nStreamData, fCollectionTime, fPreTriggerTime, uFlags);
        else
            fail = calllib('oapi', 'OdauSetupCollection', nOdauId, nChannels, nGain, nDigitalMode, fFrameFrequency, fScanFrequency, nStreamData, fCollectionTime, fPreTriggerTime, uFlags);
        end
    end
end

