function [ail, there_is_data, spool_complete, spool_status, frames_buffered] = optotrak_stop_buffering_and_write_out()
%OPTOTRAK_STOP_BUFFERING_AND_WRITE_OUT This function finishes off the spooling process, and writes the buffer contents to a previously initialised file
% There are no input arguments.
% fail is 0 on success, and the function crashes when something went wrong.
% As for the other return arguments, check DataBufferWriteData()

    DataBufferStop;
    %fprintf('Writing out buffer NOW.\n')
    there_is_data = 0;
    spool_complete = 0;
    spool_status = 0;
    frames_buffered = 0;
    while(~spool_complete)
        %do this until the spooling is complete.
        [fail, there_is_data, spool_complete, spool_status, frames_buffered] = DataBufferWriteData(there_is_data, spool_complete, spool_status, frames_buffered);
    end

    %if you used a file, the handle stays open even if you finished collecting data.
    % This is totally undocumented. The problem is, when you want to access the raw data file after you finished collecting data
    % without re-initialising the Optotrak system, the raw data will not be read correctly.
    % To counter-act this, I am closing a file I didn't open. The FileID is always 0.


    %If you initialised your destination in the memory, it will fail, but nobody cares
    FileClose(0); %close file pointer 0, which is allocated to the raw data file.

    %Now you can do whatever you want with the raw data file

end