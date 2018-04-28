function [v, w] = diff_to_twist(vr, vl, l)
% @brief Converts from a diff command to a twist drive command.
% @param vr Right wheel linear speed.
% @param vl Left wheel linear speed.
% @param l Distance between wheels.
% @return A 2D vector with linear and angular speeds.
v = (vr + vl) / 2;
w = (vr - vl) / l;