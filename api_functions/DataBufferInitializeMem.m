function [ fail, uDataId, pMemory ] = DataBufferInitializeMem( uDataId, pMemory )
%DATABUFFERINITIALIZEMEM This function reserves memory for the data buffer to be downloaded.
%   -> uDataId is the device identifier, as follows:
%       0: OPTOTRAK
%       1: DATA_PROPRIETOR, but this wasn't in the manual
%       2: ODAU1
%       3: ODAU2
%       4: ODAU3
%       5: ODAU4
%   -> pMemory is a piece of memory where the data will be stored to.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    error('If you want to buffer data, you need to allocate memory. In order to to this, you need to know how what data type you want to received. Adjust DataBufferInitializeMem(), so the pointer would match your data type.')
    %Comment out one of the following lines, depending on the type of data you want to get.

    %Memory_pointer = libpointer('voidPtr', pMemory); %this is initialised as 'SpoolPtrType', but the header file says it's just void.
    %Memory_pointer = libpointer('s_position3dPtr', pMemory); %This is for 3D x-y-z data
    %Memory_pointer = libpointer('OptotrakRigidStruct', pMemory); %this is for the rigid body stuff only
    %Memory_pointer = libpointer('TransformationStructPtr', pMemory); %This contains both the 3D and the 6D data. Unfortunately Matlab hates nested structures, so I don't think this will work. But it might be good for allocating memory.

    if(new_or_old)
        fail = calllib('oapi64', 'DataBufferInitializeMem', uDataId, Memory_pointer);
    else
        fail = calllib('oapi', 'DataBufferInitializeMem', uDataId, Memory_pointer);
    end

    % Get updated data with the pointer
    pMemory = get(Memory_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear Memory_pointer;

end

