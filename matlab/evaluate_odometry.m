function evaluate_odometry(data_file, l, d, n)
% @param data_file
% @param l 
% @param d
% @param n
figure;
hold on;
[ts, sd, rt, lt] = read_robot_data(data_file);
[t, vr, vl] = diff_from_encoders(ts, rt, lt, n, d);
initial_pose = zeros(3, 1);
true_trajectory = compute_trajectory(t, vr, vl, l, initial_pose);
cmd_vr = mean(vr) * ones(size(vr));
cmd_vl = mean(vl) * ones(size(vl));
cmd_trajectory = compute_trajectory(t, cmd_vr, cmd_vl, l, initial_pose);
plot_trajectory(t, cmd_trajectory, true_trajectory);
