%% Test rotation_radius function

% Several tests to rotation_radius function
[R] = rotation_radius(1, 1, 1);
assert(isequal(0, R));

[R] = rotation_radius(1, 1, 0.5);
assert(isequal(0, R));

[R] = rotation_radius(1, -1, 1);
assert(isequal(0, R));

[R] = rotation_radius(-1, 1, 1);
assert(isequal(0, R));

[R] = rotation_radius(2, 1, 1);
assert(isequal(3, R));

[R] = rotation_radius(1, 2, 1);
assert(isequal(-3, R));