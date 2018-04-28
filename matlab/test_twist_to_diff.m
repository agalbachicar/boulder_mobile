%% Test twist_to_diff function

% Several tests to twist_to_diff function
[vr, vl] = twist_to_diff(1, 0, 1);
assert(isequal([1, 1], [vr, vl]));

[vr, vl] = twist_to_diff(-1, 0, 1);
assert(isequal([-1, -1], [vr, vl]));

[vr, vl] = twist_to_diff(0, 1, 1);
assert(isequal([0.5, -0.5], [vr, vl]));
 
[vr, vl] = twist_to_diff(0, -1, 1);
assert(isequal([-0.5, 0.5], [vr, vl]));
