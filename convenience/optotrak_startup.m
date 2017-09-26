function [ fail ] = optotrak_startup()
%OPTOTRAK_STARTUP This function loads the Optotrak library, and
%initialises the system. It also sets up data collection with it.
    %Check if the first step is done.
    if(exist('api_prototypes.m', 'file') ~= 2)
        %if we got here, then most probably the object files are missing.
        error('The Optotrak API function prototype file is missing or not in the path. Please run RUNME.m first to generate the necessary files')
    end
    if(~(libisloaded('oapi64') || libisloaded('oapi')))
        %if the library is not loaded, load it.
        if(isunix)
            if(~libisloaded('oapi64'))
                %load the library
                loadlibrary('oapi64.lib', @api_prototypes)
            end
        else
            if(new_or_old)
                %64-bit
                if(~libisloaded('oapi64'))
                    %load the library
                    loadlibrary('oapi64.dll', @api_prototypes)
                end
            else
                %64-bit
                if(~libisloaded('oapi'))
                    %load the library
                    loadlibrary('oapi.dll', @api_prototypes)
                end
            end
        end
    else
        fprintf('OAPI library is already loaded.\n')
    end
    %% Initialise the Optotrak system.
    % Just in case, re-initialise the system. In order to prevent error messages, shut down the system first.
    TransputerShutdownSystem;
    %let's see if we are connected.
    if(TransputerDetermineSystemCfg('transputer_discovery.log')) %You must give this a file name, despite what's written in the manual.
        error('TransputerDetermineSystemCfg failed. Make sure that the Optotrak system is connected to the computer, and is turned on.')
    end

    %delete transputer_discovery.log %we are in a function, so if something fails, manual intervention will be necessary anyway.
    %now load the network information file TransputerDetermineSystemCfg just generated at
    %...ndigital/realtime by default
    if(TransputerLoadSystem('system'))
        optotrak_tell_me_what_went_wrong;
        error('TransputerLoadSystem failed. Try TransputerDetermineSystemCfg() first. Check the log file if you can see your devices.')
    end

    pause(1); % need to wait.

    loglevel = 87; %This is to set the followng flags: OPTO_LOG_ERRORS_FLAG, OPTO_LOG_STATUS_FLAG, OPTO_LOG_WARNINGS_FLAG, OPTO_SECONDARY_HOST_FLAG, OPTO_ASCII_RESPONSE_FLAG
    if(TransputerInitializeSystem(loglevel))
        %Sorry about this, but had to do it :) You should never get here
        %anyway.
        optotrak_tell_me_what_went_wrong;
        error('TransputerInitializeSystem failed. Something must have gone very wrong with the initialisation.')
    end
    
    pause(3); % need to wait.
    
     
    %if we didn't fail so far, we can toss this parameter back:
    fail = 0;


end

