function [Fl_fit, Fr_fit] = estimate_rear_drive_forces(robot_model, vx, vy, omega, delta, alpha)
  Fl = zeros(size(delta)); Fr = zeros(size(delta));
  for i = 1:length(delta)
    Fyf = -(robot_model.Calpha(1) * alpha(1, i) + robot_model.Calpha(2) * alpha(2, i));
    Fyb = -(robot_model.Calpha(3) * alpha(3, i) + robot_model.Calpha(4) * alpha(4, i));
    b = [-omega(i) * vy(i) * robot_model.m + Fyf * sin(delta(i));
         -robot_model.a1 * Fyf * cos(delta(i)) + robot_model.a2 * Fyb];
    A = [1, 1; robot_model.w/2,  -robot_model.w/2];
    F = inv(A) * b;
    Fr(i) = F(1);
    Fl(i) = F(2);
  end;
  N = length(unique(delta));
  Fl_fit_coeff = polyfit(delta, Fl, min(N-1, 10));
  Fl_fit = @(delta)(polyval(Fl_fit_coeff, delta));
  Fr_fit_coeff = polyfit(delta, Fr, min(N-1, 10));
  Fr_fit = @(delta)(polyval(Fr_fit_coeff, delta));
end
