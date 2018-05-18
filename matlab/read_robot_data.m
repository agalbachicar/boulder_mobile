function [t, rt, lt] = read_robot_data(data_file)
% @brief Reads robot data from a tab-delimited CSV file.
% @param data_file path to robot data file.  
% @return t, rt, lt sampling times in s, left encoder tick
%         count and right encoder tick count.
data = dlmread(data_file);
t = data(:, 1) * 1e-3;
lt = data(:, 2);
rt = data(:, 3);
