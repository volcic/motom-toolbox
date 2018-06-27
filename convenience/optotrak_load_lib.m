%This script loads the optotrak library.

%Check if the first step is done.
if(exist('api_prototypes.m', 'file') ~= 2)
    %if we got here, then most probably the object files are missing. 
    error('The Optotrak API function prototype file is missing or not in the path. Please run RUNME.m first to generate the necessary files')
end

if(isunix)
    if(~libisloaded('liboapi'))
        %load the library
        loadlibrary('liboapi.so', @api_prototypes)
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