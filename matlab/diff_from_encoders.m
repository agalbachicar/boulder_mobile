function [t, vr, vl] = diff_from_encoders(ts, rt, lt, n, d)
% @brief Computes wheel velocities from encoder readings.
% @param ts sampling times, in s.
% @param rt right encoder tick count.
% @param lt left encoder tick count.
% @param n encoders' tick count per turn.
% @param d wheels' diameter, in m.
% return t, vr, vl measurement times in s, right wheel linear
% velocities in m/s and left linear velocities in m/s.
dts = ts(2:end) - ts(1:end-1);
dlt = lt(2:end) - lt(1:end-1);
drt = rt(2:end) - rt(1:end-1);
vr = (pi * d / n) * (drt ./ dts);
vl = (pi * d / n) * (dlt ./ dts);
t = ts(1:end-1) .+ dts / 2;
