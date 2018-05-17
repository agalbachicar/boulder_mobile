function [t, sd, rt, lt] = read_robot_data(data_file)
% @brief Reads robot data from a tab-delimited CSV file.
% @param data_file Path to robot data file.  
% @return sampling times t, in s; sonar distance
%         readings, in m; and left and right encoder
%         tick counts.
data = dlmread(data_file);
t = data(:, 1) * 1e-3;
sd = data(:, 2) * 1e-2;
lt = data(:, 3);
rt = data(:, 4);
