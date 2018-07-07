function Calpha = estimate_sideslip_coeff(robot_model, vx, vy, omega, delta, alpha)
  b = (-robot_model.m * vx .* omega);
  A = alpha.' .* [cos(delta) cos(delta) ones(size(delta)) ones(size(delta))];
  Calpha = (b\A).';
end
