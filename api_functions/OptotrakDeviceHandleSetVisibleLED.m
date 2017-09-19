function [ fail, nDeviceHandleId, nLED, uState ] = OptotrakDeviceHandleSetVisibleLED( nDeviceHandleId, nLED, uState )
%OPTOTRAKDEVICEHANDLESETVISIBLELED This function allows you to touch the LED in the selected device.
%   -> nDeviceHandleId is the device handle which tells which device we are adjusting
%   -> nLED is the led's number to be used. The first LED (nLED=1) is 'reserved', and this will throw an error when you adjust it.
%   -> uState is a binary mask, defined as follows:
%       0: VLEDST_OFF which turns the LED off
%       1: VLEDST_ON which turns the LED on
%       2: VLEDST_BLINK starts blinking at an unspecified frequency and duty cycle.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    if(new_or_old)
        fail = calllib('oapi64', 'OptotrakDeviceHandleSetVisibleLED', nDeviceHandleId, nLED, uState );
    else
        fail = calllib('oapi', 'OptotrakDeviceHandleSetVisibleLED', nDeviceHandleId, nLED, uState );
    end

end