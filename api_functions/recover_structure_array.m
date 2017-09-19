function [ recovered_structure ] = recover_structure_array( pointer, length )
%RECOVER_STRUCTURE_ARRAY This function reads a structure array from the
%memory, provided that you give it a pointer and tell it how many elements
%are there in the array.
%   -> pointer is a C-pointer
%   -> length is the number of elements in the structure array.

    %tell matlab that we are going to play with a structure
    recovered_structure = get(pointer, 'value');

    %I did this to keep the addressing similar as if it was in C.
    for(i=0:length-1)
        %generate the new pointer, so we can resolve it in the memory.
        generated_pointer = pointer + i;
        recovered_structure(i+1) = get(generated_pointer, 'Value');
        %clear generated_pointer; %This resolves the memory wrongly allocated by the pointer.
    end

end

