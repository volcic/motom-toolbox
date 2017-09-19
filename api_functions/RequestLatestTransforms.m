function [ fail ] = RequestLatestTransforms(  )
%REQUESTLATESTTRANSFORMS This function tells the Optotrak system to prepare to send the freshest 6D rigid body data available.
% You must define the rigid bodies using RigidBodyAdd() or RigidBodyAddFromFile(), so the system could actually do the conversion.
% Make sure you wait until DataIsReady() says so, and then you can call DataReceiveLatestRaw().
% Also make sure that you have only one request running at the time, otherwise you will corrput data.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    if(new_or_old)
        fail = calllib('oapi64', 'RequestLatestTransforms');
    else
        fail = calllib('oapi', 'RequestLatestTransforms');
    end

end

