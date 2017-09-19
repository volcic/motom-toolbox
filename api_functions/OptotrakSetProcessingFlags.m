function [ fail, uFlags ] = OptotrakSetProcessingFlags( uFlags )
%OPTOTRAKSETPROCESSINGFLAGS Set or clear some processing flags from the API.
% You also can change these at optotrak.ini. But, should you need this, here it is:
% These are initalised in binary, so you'll need to add these numbers if you want to set muliple flags.
% You'll need to call TransputerInitializeSystem('') after this, carefully avoiding using a config file.
%   -> uFlags
%       0 (0x00000000): Clear all flags
%       1 (0x00000001): OPTO_LIB_POLL_REAL_DATA: blocking mode in real-time data transfers
%       2 (0x00000002): OPTO_CONVERT_ON_HOST: Makes the raw data to be converted in the host computer, as opposed to the system. Handy if you need more performance
%       4 (0x00000004): OPTO_RIGID_ON_HOST: Makes the rigid body calculations to be done on the host computer. This also can take off computational load from the system.
%       8 (0x00000008): OPTO_USE_INTERNAL_NIF: Use the network information in the device, as opposed to reading it from a file
%      16 (0x00000010): OPTO_USE_PRIMITIVE_RIGID_BODY_ALGORITHM: Undocumented, but can guess what it does :)
%      32 (0x00000020): OPTO_RIGID_NO_UPDATE3DDATA_MISSINGIFOFFANGLE: Undocumented
%      64 (0x00000040): OPTO_RIGID_NO_UPDATE3DDATA_MISSINGIFMAXERROR: Undocumented
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    if(new_or_old)
        fail = calllib('oapi64', 'OptotrakSetProcessingFlags', uFlags);
    else
        fail = calllib('oapi64', 'OptotrakSetProcessingFlags', uFlags);
    end

end

