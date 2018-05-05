%% Test diff_to_twist function

% Several tests to diff_to_twist function
[v, w] = diff_to_twist(1, 0, 1);
assert(isequal([0.5, 1], [v, w]));

[v, w] = diff_to_twist(0, 1, 1);
assert(isequal([0.5, -1], [v, w]));

[v, w] = diff_to_twist(1, 1, 1);
assert(isequal([1, 0], [v, w]));

[v, w] = diff_to_twist(1, -1, 1);
assert(isequal([0, 2], [v, w]));

[v, w] = diff_to_twist(0, 0, 1);
assert(isequal([0, 0], [v, w]));
