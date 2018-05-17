function [traj] = compute_trajectory(t, vr, vl, l, pose_i)
% @brief Computes odometry trajectory for a diff-drive vehicle.
% @param t Times
traj = zeros(3, length(t));
traj(:, 1) = pose_i;
for ii=2:length(t)
  traj(:, ii) = odometry_step(vr(ii), vl(ii),
                              l, traj(:,ii-1),
                              t(ii) - t(ii-1));
end
