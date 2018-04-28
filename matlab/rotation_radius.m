function [R] = rotation_radius(vr, vl, l)
% @brief Computes the 'instantenous curvature center' / 'instantaneous
% rotation center' radius. It's given by:
% @param vr Right wheel linear speed. 
% @param vl Left wheel linear speed.
% @ return When vr == vl, it returns 0. Otherwise, R.
if vr == vl
    R = 0;
else
    R = l * (vr + vl) / (vr - vl);
end
    