robot_model = struct;
robot_model.m = 0.62;  % Kg
robot_model.d = 0.066; % m
robot_model.l = 0.155; % m
robot_model.a2 = 0.099; % m
robot_model.a1 = robot_model.l - robot_model.a2;
robot_model.w = 0.158; % m
robot_model.Iz = robot_model.m/12 * (robot_model.w^2 + robot_model.l^2);

lt_samples = []; rt_samples = [];
cwl_samples = []; cwr_samples = []; s_samples = [];
line_data_files = dir('../measurements/line_*.csv');
for i = 1:length(line_data_files)
  line_data_file = strcat(line_data_files(i).folder, '/', line_data_files(i).name);
  [ts, lt, rt, cwl, cwr, delta, r, theta, s] = read_robot_data(line_data_file);
  lt_samples = vertcat(lt_samples, lt(5:end-5));
  rt_samples = vertcat(rt_samples, rt(5:end-5));
  cwl_samples = vertcat(cwl_samples, cwl(5:end-5));
  cwr_samples = vertcat(cwr_samples, cwr(5:end-5));
  s_samples = vertcat(s_samples, s(5:end-5));
end
[robot_model.nl, robot_model.nr] = estimate_encoders_n(robot_model, cwl_samples, cwr_samples,...
                                                       lt_samples, rt_samples, s_samples);

arc_data_files = dir('../measurements/arc_*.csv');
vx_samples = zeros(size(arc_data_files));
vy_samples = zeros(size(arc_data_files));
omega_samples = zeros(size(arc_data_files));
delta_samples = zeros(size(arc_data_files));
for i = 1:length(arc_data_files)
  arc_data_file = strcat(arc_data_files(i).folder, '/', arc_data_files(i).name);
  [ts, lt, rt, cwl, cwr, delta, r, theta, s] = read_robot_data(arc_data_file);
  [t, vx, vy, omega] = estimate_planar_twist(robot_model, ts, lt, rt, cwl, cwr, delta, r, theta);
  vx_samples(i) = mean(vx); vy_samples(i) = mean(vy);
  omega_samples(i) = mean(omega); delta_samples(i) = mean(delta);
end
vx_samples = vertcat(vx_samples, vx_samples);
vy_samples = vertcat(vy_samples, -vy_samples);
omega_samples = vertcat(omega_samples, -omega_samples);
delta_samples = vertcat(delta_samples, -delta_samples);

alpha_estimates = estimate_sideslip_angles(robot_model, vx_samples, vy_samples,...
                                           omega_samples, delta_samples);

robot_model.Calpha = estimate_sideslip_coeff(robot_model, vx_samples, vy_samples,...
                                             omega_samples, delta_samples, alpha_estimates);

[robot_model.Fl, robot_model.Fr] = estimate_rear_drive_forces(robot_model, vx_samples, vy_samples,...
                                                              omega_samples, delta_samples, alpha_estimates);

delta = linspace(-pi/8, pi/8, 50);
plot(delta, robot_model.Fl(delta) * robot_model.d/2, 'b',...
     delta, robot_model.Fr(delta) * robot_model.d/2, 'r');

t0 = 0;
tf = 10;
max_steering = 28;
kmax = tan(max_steering * pi / 180) / robot_model.l;
deltafun = @(t) atan(robot_model.l * kmax * (t - t0) / tf);
%deltafun = @(t) max_steering * pi / 180 * sin(2 * pi * (t - t0)/tf);
odefun = @(t, y) planar_robot_dynamics(robot_model, t, y, deltafun(t));
[t, twist] = ode45(odefun, [t0 tf], [0.2;0.;0.]);
x = cumtrapz(t, twist(:, 1));
y = cumtrapz(t, twist(:, 2));
theta = cumtrapz(t, twist(:, 3));
%plot(x, y);
%plot(t, x, 'b', t, y, 'r', t, theta, 'g');
%lsode_options('absolute tolerance', 0.01);
%lsode_options('relative tolerance', 0.01);
%lsode_options('integration method', 'non-stiff');
%lsode_options('maximum order', 3);
%lsode(odefun, [0.5;0.;0.], linspace(0., 1.0, 100))
