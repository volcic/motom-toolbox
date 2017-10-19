function [ fail, nRigidBodyId ] = RigidBodyDelete( nRigidBodyId )
%RIGIDBODYDELETE
% [ fail, nRigidBodyId ] = RigidBodyDelete( nRigidBodyId )
% This function deletes the definition of a specified rigid body in the Optotrak system.
%   -> nRigidBodyId is the identifier of the rigid body you want to get rid of
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    if(new_or_old)
        fail = calllib('oapi64', 'RigidBodyDelete', nRigidBodyId);
    else
        fail = calllib('oapi', 'RigidBodyDelete', nRigidBodyId);
    end

end

