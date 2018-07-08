robot_model = struct;
robot_model.m = 0.62;  % Kg
robot_model.d = 0.066; % m
robot_model.l = 0.155; % m
robot_model.a2 = 0.099; % m
robot_model.a1 = robot_model.l - robot_model.a2;
robot_model.w = 0.158; % m
robot_model.Iz = robot_model.m/12 * (robot_model.w^2 + robot_model.l^2);

arc_data_files = dir('../measurements/arc_*.csv');
r_samples = zeros(size(arc_data_files));
omega_samples = zeros(size(arc_data_files));
delta_samples = zeros(size(arc_data_files));
td_samples = zeros(size(arc_data_files));
for i = 1:length(arc_data_files)
  arc_data_file = strcat(arc_data_files(i).folder, '/', arc_data_files(i).name);
  [ts, lt, rt, cwl, cwr, delta, r, theta, s] = read_robot_data(arc_data_file);
  r_samples(i) = mean(r); delta_samples(i) = mean(delta);
  omega_samples(i) = mean(diff(theta) ./ diff(ts));
  td_samples(i) = ts(end) - ts(1);
end
r_samples = vertcat(r_samples, -r_samples);
td_samples = vertcat(td_samples, td_samples);
omega_samples = vertcat(omega_samples, -omega_samples);
delta_samples = vertcat(delta_samples, -delta_samples);

[robot_model.Calpha, robot_model.Fl, robot_model.Fr] = ...
    estimate_planar_dynamics(robot_model, td_samples, r_samples, omega_samples, delta_samples);

% figure;
% delta = linspace(-pi/6, pi/6, 50);
% plot(delta, robot_model.Fl(delta), 'b',...
%      delta, robot_model.Fr(delta), 'r');

t0 = 0;
tf = 10;
max_steering = 25;
kmax = tan(max_steering * pi / 180) / robot_model.l;
deltafun = @(t) atan(robot_model.l * kmax * (t - t0) / tf);
%deltafun = @(t) max_steering * pi / 180 * sin(2 * pi * (t - t0)/tf);
odefun = @(t, y) planar_dynamics(robot_model, t, y, deltafun(t));
[t, twist] = ode45(odefun, [t0 tf], [0.28;0.;0.]);
theta = cumtrapz(t, twist(:, 3));
x = cumtrapz(t, twist(:, 1) .* cos(theta) - twist(:, 2) .* sin(theta));
y = cumtrapz(t, twist(:, 1) .* sin(theta) + twist(:, 2) .* cos(theta));
figure;
plot(x, y);
x(end)
y(end)
theta(end) * 180 / pi
sum(sqrt(diff(x).^2 + diff(y).^2))
%plot(t, twist(:, 1), 'b', t, twist(:, 2), 'r', t, twist(:, 3), 'g');
%lsode_options('absolute tolerance', 0.01);
%lsode_options('relative tolerance', 0.01);
%lsode_options('integration method', 'non-stiff');
%lsode_options('maximum order', 3);
%lsode(odefun, [0.5;0.;0.], linspace(0., 1.0, 100))
