function [Calpha, Fl, Fr] = estimate_planar_dynamics(robot_model, td, r, omega, delta)
  v = r .* omega;
  function err = cbeta_err(cbeta)
    beta = cbeta * delta; vx = v .* cos(beta); vy = v .* sin(beta);
    [robot_model.Calpha, robot_model.Fl, robot_model.Fr] = ...
       estimate_planar_dynamics_impl(robot_model, vx, vy, omega, delta);

    function [value, isterminal, direction] = eventfn(t, y)
      value = double(abs(y) > 0.01);
      isterminal = ones(size(value));
      direction = zeros(size(value));
    end
    options = odeset('Events', @eventfn);

    err = 0;
    for i = 1:length(r)
      odefun = @(t, y) planar_dynamics(robot_model, t, y, delta(i));
      [t, twist] = ode45(odefun, [0 td(i)], [vx(i); vy(i); omega(i)], options);
      rc = sqrt(twist(:, 1).^2 + twist(:, 2).^2) ./ twist(:, 3);
      theta = cumtrapz(t, twist(:, 3));
      x = cumtrapz(t, twist(:, 1) .* cos(theta) - twist(:, 2) .* sin(theta));
      y = cumtrapz(t, twist(:, 1) .* sin(theta) + twist(:, 2) .* cos(theta));
      s = sum(sqrt(diff(x).^2 + diff(y).^2));
      err = err + (s - r(i) * omega(i) * td(i))^2;
    end
  end
  function [c, ceq] = cbeta_ineq(cbeta)
    beta = cbeta * delta; vx = v .* cos(beta); vy = v .* sin(beta);
    alpha = estimate_sideslip_angles(robot_model, vx, vy, omega, delta);
    c = alpha(:, 1); ceq = [];
  end
  options = optimset('MaxIter', 100);
  [Cbeta, err] = fmincon(@cbeta_err, 1.0, [], [], [], [], 0, 1, @cbeta_ineq, options)
  beta = Cbeta * delta; vx = v .* cos(beta); vy = v .* sin(beta);
  [Calpha, Fl, Fr, Fl_coeff, Fr_coeff] = estimate_planar_dynamics_impl(robot_model, vx, vy, omega, delta)
end

function [Calpha, Fl, Fr, Fl_coeff, Fr_coeff] = estimate_planar_dynamics_impl(robot_model, vx, vy, omega, delta)
  alpha = estimate_sideslip_angles(robot_model, vx, vy, omega, delta);
  robot_model.Calpha = estimate_sideslip_coeff(robot_model, vx, vy, omega, delta, alpha);
  [robot_model.Fl, robot_model.Fr, Fl_coeff, Fr_coeff] = estimate_rear_drive_forces(robot_model, vx, vy,...
                                                                                    omega, delta, alpha);
  Calpha = robot_model.Calpha; Fl = robot_model.Fl; Fr = robot_model.Fr;
end
