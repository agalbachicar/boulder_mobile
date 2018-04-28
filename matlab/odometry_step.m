function [pose_f] = odometry_step(vr, vl, l, pose_i, dt)
% @brief Computes the odometry for a diff-drive vehicle.
% @param vr Right wheel linear speed.
% @param vl Left wheel linear speed.
% @param l Distance between wheels.
% @param pose_i Initial vehicle 2D pose.
% @param dt Time step.
% @return 2D pose after `dt` time step.
R = rotation_radius(vr, vl, l);
[v, w] = diff_to_twist(vr, vl, l);
phase = w * dt;
if w ~= 0
    ICC = [pose_i(1)-R*sin(pose_i(3)); pose_i(2)+R*cos(pose_i(3))];
    pose_f = ...
        [cos(phase) -sin(phase) 0; sin(phase) cos(phase) 0; 0 0 1] * ...
        [pose_i(1)-ICC(1); pose_i(2)-ICC(2); pose_i(3)] + ...
        [ICC(1); ICC(2); phase];
else
   pose_f = [pose_i(1)-v*dt*sin(pose_i(3)); ...
             pose_i(2)+v*dt*cos(pose_i(3)); ...
             pose_i(3)]; 
end
