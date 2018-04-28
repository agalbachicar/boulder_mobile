function [fc] = plot_trajectory(poses, t, fc)
figure(fc);
fc = fc + 1;
plot(t, poses(1,:));
grid;
title('x = f(t)');
ylabel('x');
xlabel('t');

figure(fc);
fc = fc + 1;
plot(t, poses(2,:));
grid;
title('y = f(t)');
ylabel('y');
xlabel('t');

figure(fc);
fc = fc + 1;
plot(t, poses(3,:));
grid;
title('theta = f(t)');
ylabel('theta');
xlabel('t');

figure(fc);
fc = fc + 1;
plot(poses(1,:), poses(2,:));
grid;
title('Trajectory');
xlabel('x');
ylabel('y');
