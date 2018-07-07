function [t, vl, vr] = diff_from_encoders(ts, lt, rt, nl, nr, d)
% @brief Computes wheel velocities from encoder readings.
% @param ts sampling times, in s.
% @param lt left encoder tick count.
% @param rt right encoder tick count.
% @param nl left encoder tick count per turn.
% @param nr right encoder tick count per turn.
% @param d wheels' diameter, in m.
% return t, vr, vl measurement times in s, right wheel linear
% velocities in m/s and left linear velocities in m/s.
t = ts(1:end-1) + diff(ts) / 2;
 dt = diff(ts);
 dl = diff(pi * d * lt ./ nl);
 dr = diff(pi * d * rt ./ nr);
 vl = dl ./ dt;
 vr = dr ./ dt;
% n = 2;
% ix = idivide(1:length(t), n) + 1;
% dt = ts(1+n:end) - ts(1:end-n);
% xl = pi * d * lt ./ nl;
% dl = xl(1+n:end) - xl(1:end-n);
% vl = (dl ./ dt);
% vl = vl(ix);
% xr = pi * d * rt ./ nr;
% dr = xr(1+n:end) - xr(1:end-n);
% vr = (dr ./ dt);
% vr = vr(ix);
