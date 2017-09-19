function [ binary_answer ] = new_or_old( )
%NEW_OR_OLD checks whether the 32 or the 64-bit libraries are used.
%   this is done so by checking if the 'use_64_bits' exists in the
%   'generated_api_files' directory, which has to be in your path.
%   Returns 1 if 64-bits are to be used, and returns 0 when 32-bits are to
%   be used. This is to make sure the appropriate library is used.

    if(exist('use_64_bits') == 2)
        binary_answer = 1; %return 1 if 64-bit
    else
        binary_answer = 0; %return 0 if 32-bit
    end


end

