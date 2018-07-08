function dtwist_dt = planar_dynamics(robot_model, t, twist, delta)
  vx = twist(1); vy = twist(2); omega = twist(3);
  alpha = estimate_sideslip_angles(robot_model, vx, vy, omega, delta);
  Fyf = -(robot_model.Calpha(1) * alpha(1) + robot_model.Calpha(2) * alpha(2));
  Fyb = -(robot_model.Calpha(3) * alpha(3) + robot_model.Calpha(4) * alpha(4));
  Fxl = robot_model.Fl(delta);
  Fxr = robot_model.Fr(delta);
  dtwist_dt = [(-Fyf * sin(delta) + Fxl + Fxr) / robot_model.m + omega * vy;
               (Fyf * cos(delta) + Fyb) / robot_model.m - omega * vx;
               (robot_model.a1 * Fyf * cos(delta) - robot_model.a2 * Fyb...
                + robot_model.w/2 * (Fxr - Fxl)) / robot_model.Iz];
end
