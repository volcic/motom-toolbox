function [ fail, nRigidBodyId, nRotationMethod ] = RigidBodyChangeFOR( nRigidBodyId, nRotationMethod )
%RIGIDBODYCHANGEFOR
% [ fail, nRigidBodyId, nRotationMethod ] = RigidBodyChangeFOR( nRigidBodyId, nRotationMethod )
% This function changes the coordinate systm in which the rigid body positions are calculated.
%   -> nRigidBodyId is the identifier of the rigid body you specified when added/loaded it
%   -> nRotationMethod can be two values:
%       4 (0x0004): OPTOTRAK_STATIC_RIGID_FLAG tells the system to use the rigid body's current position and orientation as the origin of its local cooridnate system
%       8 (0x0008): OPTOTRAK_CONSTANT_RIGID_FLAG tells the Optotrak system to measure a rigid body's movement with respect to an other rigid body's movement
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    if(isunix)
        fail = calllib('liboapi', 'RigidBodyChangeFOR', nRigidBodyId, nRotationMethod);
    else
        if(new_or_old)
            fail = calllib('oapi64', 'RigidBodyChangeFOR', nRigidBodyId, nRotationMethod);
        else
            fail = calllib('oapi', 'RigidBodyChangeFOR', nRigidBodyId, nRotationMethod);
        end
    end
end