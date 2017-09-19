function [ fail, nDeviceHandlerId, pdtProperty, uPropertyId ] = OptotrakDeviceHandleGetProperty( nDeviceHandlerId, pdtProperty, uPropertyId )
%OPTOTRAKDEVICEHANDLEGETPROPERTY This function fetches a selected property for a selected device.
% This is a bit cryptic this way, so let me elaborate here:
%   -> nDeviceHandlerId is the device handle
%   -> pdtProperty is where the property obtained by this function is being written into
%   -> uPropertyId is a number, which is initialised in the API as a binary mask. In Matlab, this can be a decimal number, as follows:
%       0: DH_PROPERTY_UNKNOWN doesn't seem to do much
%       1: DH_PROPERTY_NAME gets the selected device's name
%       2: DH_PROPERTY_MARKERS_TO_FIRE tells you how many markers will be used.
%       3: DH_PROPERTY_MAX_MARKERS is the maximum mumbers of markers the device can have
%       4: DH_PROPERTY_STARTMARKERPERIOD tells you which marker will be activated first within a period
%       5: DH_PROPERTY_SWITCHES tells you how many switches are on the device
%       6: DH_PROPERTY_VLEDS tells you how many visible LEDs are there on the device
%       7: DH_PROPERTY_PORT tells you which SCU port is the device being plugged in
%       8: DH_PROPERTY_ORDER '...index within the port'
%       9: DH_PROPERTY_SUBPORT tells you which subport the device is connected to
%      10: DH_PROPERTY_FIRINGSEQUENCE tells you which order the markers are being 'fired' at
%      11: DH_PROPERTY_HAS_ROM tells you whether the selected device has a ROM
%      12: DH_PROPERTY_TOOLPORTS tells you how many ports the selected strober has
%      13: DH_PROPERTY_3020_CAPABILITY tells you if your device can use the Optotrak 3020 strober
%      14: DH_PROPERTY_3020_MARKERSTOFIRE tells you how many markers are ont he 3020 strober
%      15: DH_PROPERTY_3020_STARTMARKERPERIOD tells you which marker is going to fire first within a period
%      16: DH_PROPERTY_STATUS tells you what's happening with the device (ENABLED, FREE, INITIALIZED, UNOCCUPIED, OCCUPIED)
%      17: Undocumented, and it's not even in the header file!
%      18: DH_PROPERTY_SROM_RIGIDMARKERS is undocumented, presumably Serial-number ROM?
%      19: DH_PROPERTY_SROM_RIGIDPOSITIONS is undocumented, presumably Serial-number ROM?
%      20: DH_PROPERTY_SROM_FIRINGSEQUENCE is undocumented, presumably Serial-number ROM?
%      21: DH_PROPERTY_SROM_NORMALMARKERS is undocumented, presumably Serial-number ROM?
%      22: DH_PROPERTY_SROM_NORMALS is undocumented, presumably Serial-number ROM?
%      23: DH_PROPERTY_SROM_SERIALNUMBER is undocumented, presumably Serial-number ROM?
%      24: DH_PROPERTY_SROM_PARTNUMBER is undocumented, presumably Serial-number ROM?
%      25: DH_PROPERTY_SROM_MANUFACTURER is undocumented, presumably Serial-number ROM?
%      26: Undocumented, and it's not even in the header file!
%      27: Undocumented, and it's not even in the header file!
%      28: DH_PROPERTY_STATE_FLAGS is undocumented
%      29: DH_PROPERTY_TIP_ID is undocumented
%      30: DH_PROPERTY_SCAN_MODE_SUPPORT is undocumented
%      31: DH_PROPERTY_HAS_BUMP_SENSOR is undocumented
%      32: DH_PROPERTY_WIRELESS_ENABLED tells you whether the device is operating wirelessly
%      33: DH_PROPERTY_HAS_BEEPER is undocumented, but one can guess :)
%      34: DH_PROPERTY_DEVICE_TYPE is undocumented
%      35: DH_PROPERTY_SERIAL_NUMBER is undocumented, but one can guess :)
%      36: DH_PROPERTY_FEATURE_KEY is undocumented
%      37: DH_PROPERTY_MKR_PORT_ENCODING returns the encoded marker activation
%      38: Undocumented, and it's not even in the header file!
%      39: Undocumented, and it's not even in the header file!
%      40: Undocumented, and it's not even in the header file!
%      41: Undocumented, and it's not even in the header file!
%      42: Undocumented, and it's not even in the header file!
%      43: Undocumented, and it's not even in the header file!
%      44: Undocumented, and it's not even in the header file!
%      45: Undocumented, and it's not even in the header file!
%      46: Undocumented, and it's not even in the header file!
%      47: Undocumented, and it's not even in the header file!
%      48: DH_PROPERTY_SELECT_PROBE_CLUSTER
%      49: Undocumented, and it's not even in the header file!
%      50: DH_PROPERTY_BEEP_PATTERN is undocumented, and probably isn't supported.
%      51: DH_PROPERTY_SWITCH_INDEX is undocumented
%      52: DH_PROPERTY_TIME_SINCE_LAST_RESPONSE is a time value in seconds
%      53: DH_PROPERTY_MAX_MARKER_VOLTAGE is the maximum marker voltage supported by the strober
%      54: DH_PROPERTY_SMART_MARKERS tells you if the strober supports/uses 'smart markers'
%      55: DH_PROPERTY_SROM_IS_CACHED tells you if the device's SROM is cached in the SCU
%      56: DH_PROPERTY_SROM_ID returns the serial numbers of all the devices attached to the SCU
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    dtProperty_pointer = libstruct('DeviceHandleProperty', pdtProperty);
    if(new_or_old)
        fail = calllib('oapi64', 'OptotrakDeviceHandleGetProperty', nDeviceHandlerId, dtProperty_pointer, uPropertyId);
    else
        fail = calllib('oapi', 'OptotrakDeviceHandleGetProperty', nDeviceHandlerId, dtProperty_pointer, uPropertyId);
    end

    % Get updated data with the pointer
    pdtProperty = get(dtProperty_pointer);

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear dtProperty_pointer;
end