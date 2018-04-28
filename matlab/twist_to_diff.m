function [v_r, v_l] = twist_to_diff(v, w, l)
% @brief Converts from a twist command to a diff drive command.
% @param v Linear speed.
% @param w Angular speed.
% @param l Distance between wheels.
% @return A 2D vector with right and left linear wheel speeds.
v_r = v + l * w / 2;
v_l = v - l * w / 2;