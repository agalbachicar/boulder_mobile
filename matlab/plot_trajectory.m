function plot_trajectory(t, varargin)
  colors = get(gca, 'ColorOrder');
  
  subplot(2, 2, 1);
  hold on;
  for k = 1:length(varargin)
    traj = varargin{k};
    plot(t, traj(1, :) * 100.0,
         'Color', colors(k, :));  
  end
  title('x = f(t)');
  ylabel('x [cm]');
  xlabel('t [s]');
  grid;

  subplot(2, 2, 2);
  hold on;
  for k = 1:length(varargin)
    traj = varargin{k};
    plot(t, traj(2, :) * 100.0,
         'Color', colors(k, :));
  end
  title('y = f(t)');
  ylabel('y [cm]');
  xlabel('t [s]');
  grid;
  
  subplot(2, 2, 3);
  hold on;
  for k = 1:length(varargin)
    traj = varargin{k};
    plot(t, traj(3, :) * 100.0,
         'Color', colors(k, :));
  end  
  title('\theta$ = f(t)');
  ylabel('\theta [rad]');
  xlabel('t [s]');
  grid;
  
  subplot(2, 2, 4);
  hold on;
  for k = 1:length(varargin)
    traj = varargin{k};
    
    traj = traj(:, 1:5:end);
%    tr = (traj([1, 2], 2:end) -
%          traj([1, 2], 1:end-1));
%    mean_tr = mean(sqrt(sum(tr.^2, 2)));
    x = traj(1, :) * 100.0;
    y = traj(2, :) * 100.0;
    u = cos(traj(3, :));
    v = sin(traj(3, :));
    quiver(x, y, u, v, 'Color', colors(k, :));
  end
  title('(x, y, \theta) = f(t)');
  xlabel('x [cm]');
  ylabel('y [cm]');
  axis equal;
  grid;
