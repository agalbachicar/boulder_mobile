function [t, vr, vl] = diff_from_encoders(ts, rt, lt, n, d)
% @brief Computes wheel velocities from encoder readings.
% @param ts Sampling times, in s.
% @param rt Right encoder tick count.
% @param lt Left encoder tick count.
% @param n Encoder ticks per turn.
% @param d Wheel diamater, in m.
% return Wheel tangential speeds, in m/s.
dts = ts(2:end) - ts(1:end-1);
dlt = lt(2:end) - lt(1:end-1);
drt = rt(2:end) - rt(1:end-1);
vr = (pi * d / n) * (drt ./ dts);
vl = (pi * d / n) * (dlt ./ dts);
t = ts(1:end-1) .+ dts / 2;
