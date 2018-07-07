function alpha = estimate_sideslip_angles(robot_model, vx, vy, omega, delta)
  beta  = [atan2((vy.' + (robot_model.a1 - robot_model.w/2 * sin(delta.')) .* omega.'),...
                 (vx.' - robot_model.w/2 * cos(delta.') .* omega.'));
           atan2((vy.' + (robot_model.a1 + robot_model.w/2 * sin(delta.')) .* omega.'),...
                 (vx.' + robot_model.w/2 * cos(delta.') .* omega.'));
           atan2((vy.' - robot_model.a2 * omega.'), (vx.' + robot_model.w/2 * omega.'));
           atan2((vy.' - robot_model.a2 * omega.'), (vx.' - robot_model.w/2 * omega.'))];
  alpha = beta - [delta.'; delta.'; zeros(size(delta.')); zeros(size(delta.'))];
end
