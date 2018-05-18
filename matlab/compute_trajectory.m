function [traj] = compute_trajectory(t, vr, vl, l, pose_i)
% @brief Computes odometry trajectory for a diff-drive vehicle.
% @param t measurement times.
% @param vr right wheel linear velocities, in m/s.
% @param vl left wheel linear velocities, in m/s.
% @param l wheels track base, in m.
% @param pose_i initial SE(2) pose, as in (x, y, \theta).
% @return traj trajectory of SE(2) poses.
traj = zeros(3, length(t));
traj(:, 1) = pose_i;
for ii=2:length(t)
  traj(:, ii) = odometry_step(vr(ii), vl(ii),
                              l, traj(:,ii-1),
                              t(ii) - t(ii-1));
end
