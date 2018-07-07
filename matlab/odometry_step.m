function [pose_f] = odometry_step(v, w, pose_i, dt)
% @brief Updates odometry for a diff-drive vehicle.
% @param vr Right wheel linear speed.
% @param vl Left wheel linear speed.
% @param l Distance between wheels.
% @param pose_i Initial vehicle 2D pose.
% @param dt Time step.
% @return 2D pose after `dt` time step.
R = v / w;
phase = w * dt;
if w ~= 0
    ICC = [pose_i(1)-R*sin(pose_i(3)); pose_i(2)+R*cos(pose_i(3))];
    pose_f = ...
        [cos(phase) -sin(phase) 0; sin(phase) cos(phase) 0; 0 0 1] * ...
        [pose_i(1)-ICC(1); pose_i(2)-ICC(2); pose_i(3)] + ...
        [ICC(1); ICC(2); phase];
else
   pose_f = pose_i + ...
       [cos(pose_i(3)) -sin(pose_i(3)) 0; ...
        sin(pose_i(3)) cos(pose_i(3))  0; ...
        0              0               1] * [v*dt 0 0]'; 
end
