function [ fail ] = DataIsReady(  )
%DATAISREADY Is the data ready? Yes: anything else, No: 0
%   fail: if it's non-zero, you can receive data. if it's zero, then you'll have to wait until there will be data available.

    if(new_or_old)
        fail = calllib('oapi64', 'DataIsReady');
    else
        fail = calllib('oapi', 'DataIsReady');
    end

end

