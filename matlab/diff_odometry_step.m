function [pose_f] = diff_odometry_step(vr, vl, l, pose_i, dt)
% @brief Updates odometry for a diff-drive vehicle.
% @param vr Right wheel linear speed.
% @param vl Left wheel linear speed.
% @param l Distance between wheels.
% @param pose_i Initial vehicle 2D pose.
% @param dt Time step.
% @return 2D pose after `dt` time step.
[v, w] = diff_to_twist(vr, vl, l);
pose_f = odometry_step(v, w, pose_i, dt);
