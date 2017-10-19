function [ fail, nRigidBodyId, nStartMarkers, nNumMarkers, pRigidCoordinates, pNormalCoordinates, nFlags ] = RigidBodyAdd( nRigidBodyId, nStartMarkers, nNumMarkers, pRigidCoordinates, pNormalCoordinates, nFlags )
%RIGIDBODYADD
% [ fail, nRigidBodyId, nStartMarkers, nNumMarkers, pRigidCoordinates, pNormalCoordinates, nFlags ] = RigidBodyAdd( nRigidBodyId, nStartMarkers, nNumMarkers, pRigidCoordinates, pNormalCoordinates, nFlags )
% This function adds a rigid body definition for the Optotrak system to track.
%   -> nRigidBodyId is specified by you, depending on what number you want to give it
%   -> nStartMarkers tells the Optotrak system which marker is the rigid body's first marker
%   -> nNumMarkers specifies the number of markers in the rigid body
%   -> pRigidCoordinates is an x-y-z array where the marker positions go in 'home'.
%   -> pNormalCoordinates will contain vectors that are normal (as in, perpendicular) to the markers' surface
%   -> nFlags is a binary mask, for the rigid body settings. If you want to set multiple flags, you'll need to add these numbers:
%       1 (0x0001): OPTOTRAK_UNDETERMINED_FLAG is undocumented.
%       2 (0x0002): OPTOTRAK_STATIC_XFRM_FLAG is undocumented.
%       4 (0x0004): OPTOTRAK_STATIC_RIGID_FLAG tells the system to use the rigid body's current position and orientation as the origin of its local cooridnate system
%       8 (0x0008): OPTOTRAK_CONSTANT_RIGID_FLAG tells the Optotrak system to measure a rigid body's movement with respect to an other rigid body's movement
%      16 (0x0010): OPTOTRAK_NO_RIGID_CALCS_FLAG makes the Optotrak system not to calculate positions for this rigid body
%      32 (0x0020): OPTOTRAK_DO_RIGID_CALCS_FLAG restarts the rigid body calculations for this specified rigid body
%      64 (0x0040): OPTOTRAK_QUATERN_RIGID_FLAG uses Berthold Horn's algorithm to track the rigid body. More info here: Horn, Berthold KP. "Relative orientation." International Journal of Computer Vision 4.1 (1990): 59-78.
%     128 (0x0080): OPTOTRAK_ITERATIVE_RIGID_FLAG uses the Iterative Euler Algorithm to track your rigid body. In general, it's slower, but can be more accurate.
%     256 (0x0100): OPTOTRAK_SET_QUATERN_ERROR_FLAG is undocumented
%     512 (0x0200): OPTOTRAK_SET_MIN_MARKERS_FLAG is undocumented
%    1024 (0x0400): OPTOTRAK_RIGID_ERR_MKR_SPREAD is undocumented
%    2048 (0x0800): OPTOTRAK_USE_SCALED_MAX3DERROR is undocumented
%    4096 (0x1000): OPTOTRAK_RETURN_QUATERN_FLAG makes the function return the rigid body transform in quaternion format
%    8192 (0x2000): OPTOTRAK_RETURN_MATRIX_FLAG gets your data back in the rotation matrix format
%   16384 (0x4000): OPTOTRAK_RETURN_EULER_FLAG gives you the rigid body transform in the Euler Angle format, IN RADIANS!!!
% This a computationally intensive function. Add a few seconds' worth of sleep after calling this. Also, be aware that some flags can't be set at the same time.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    RigidCoordinates_pointer = libpointer('singlePtr', pRigidCoordinates);
    NormalCoordinates_pointer = libpointer('singlePtr', pNormalCoordinates);

    if(new_or_old)
        fail = calllib('oapi64', 'RigidBodyAdd', nRigidBodyId, nStartMarkers, nNumMarkers, RigidCoordinates_pointer, NormalCoordinates_pointer, nFlags);
    else
        fail = calllib('oapi', 'RigidBodyAdd', nRigidBodyId, nStartMarkers, nNumMarkers, RigidCoordinates_pointer, NormalCoordinates_pointer, nFlags);
    end

    % Get updated data with the pointer
    pRigidCoordinates = get(RigidCoordinates_pointer, 'Value');
    pNormalCoordinates = get(NormalCoordinates_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear RigidCoordinates_pointer NormalCoordinates_pointer;

end

