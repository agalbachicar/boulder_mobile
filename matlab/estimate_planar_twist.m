function [t, vx, vy, omega] = estimate_planar_twist(robot_model, ts, lt, rt, cwl, cwr, delta, r, theta)
  [t, vl, vr] = diff_from_encoders(ts, lt, rt, robot_model.nl(cwl),...
                                   robot_model.nr(cwr), robot_model.d);
  r = r(1:end-1) + diff(r)/2;
  % steps = diff(compute_trajectory(t, vl, vr, robot_model.w, zeros(3, 1)).');
  % estimated_total_distance = sum(sqrt(steps(:, 1).^2 + steps(:, 2).^2));
  % total_distance = sum(r .* diff(theta));
  % vx = (total_distance / estimated_total_distance) * ((vl + vr) / 2);
  omega = diff(theta) ./ diff(ts);
  vx = (vl + vr) / 2;
  v = r .* omega;
  vy = sqrt(v.^2 - vx.^2)
  %vy = ((vl + vr) + 2 * omega * robot_model.a2) / 2;
  beta = 0.6 * atan(robot_model.a2 ./ r);
  vx = v .* cos(beta);
  vy = v .* sin(beta);
end
