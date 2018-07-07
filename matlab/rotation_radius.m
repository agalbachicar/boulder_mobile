function [R] = rotation_radius(vr, vl, l)
% @brief Computes the 'instantenous curvature center' / 'instantaneous
% rotation center' radius. It's given by:
% @param vr Right wheel linear speed. 
% @param vl Left wheel linear speed.
% @ return When vr == vl, it returns 0. Otherwise, R.
mask = (vr ~= vl);
R = zeros(size(vr));
R(mask) = (l/2) * (vr(mask) + vl(mask)) ./ (vr(mask) - vl(mask));
