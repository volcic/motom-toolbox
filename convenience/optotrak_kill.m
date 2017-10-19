function [ fail ] = optotrak_kill(  )
%OPTOTRAK_KILL
% [ fail ] = optotrak_kill(  )
% This function shuts down the system, and unloads the library
%from memory. This is to prevent crashes.
%   There are no arguments to this function.


    OptotrakDeActivateMarkers();
    OptotrakStopCollection();
    TransputerShutdownSystem();

    if(new_or_old)
        unloadlibrary('oapi64');
    else
        unloadlibrary('oapi');
    end


end

