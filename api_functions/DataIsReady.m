function [ fail ] = DataIsReady(  )
%DATAISREADY
% [ fail ] = DataIsReady(  )
% Is the data ready? No: 0, Yes: anything else
%   fail: if it's non-zero, you can receive data. if it's zero, then you'll have to wait until there will be data available.

    if(isunix)
        fail = calllib('liboapi', 'DataIsReady');
    else
        if(new_or_old)
            fail = calllib('oapi64', 'DataIsReady');
        else
            fail = calllib('oapi', 'DataIsReady');
        end
    end
end

