function [ts, lt, rt, cwl, cwr, delta, r, theta, s] = read_robot_data(data_file)
% @brief Reads robot data from a tab-delimited CSV file.
% @param data_file path to robot data file.  
% @return t, rt, lt sampling times in s, left encoder tick
%         count and right encoder tick count.
data = dlmread(data_file);
ts = data(:, 1) * 1e-3;
lt = data(:, 2);
rt = data(:, 3);
cwl = data(:, 4);
cwr = data(:, 5);
delta = data(:, 6) * pi / 180;
r = data(:, 7);
theta = data(:, 8) * pi / 180;
s = data(:, 9);
