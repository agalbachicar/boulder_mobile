function evaluate_odometry(data_file, l, d, n)
% @brief Evaluates odometry performance based on recorded data
%        and robot geometry by plotting side-by-side the actual
%        trajectory and the 'commanded' trajectory (using mean
%        wheel velocities, assuming constant commands).
% @param data_file path to robot data file.
% @param l wheels' track base, in m.
% @param d wheels' diameter, in m.
% @param n encoders' tick count per turn.
figure;
hold on;
[ts, rt, lt] = read_robot_data(data_file);
[t, vr, vl] = diff_from_encoders(ts, rt, lt, n, d);
initial_pose = zeros(3, 1);
true_trajectory = compute_trajectory(t, vr, vl, l, initial_pose);
cmd_vr = mean(vr) * ones(size(vr));
cmd_vl = mean(vl) * ones(size(vl));
cmd_trajectory = compute_trajectory(t, cmd_vr, cmd_vl, l, initial_pose);
plot_trajectory(t, cmd_trajectory, true_trajectory);
