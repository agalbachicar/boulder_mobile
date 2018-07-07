function [nl_fit, nr_fit] = estimate_encoders_n(robot_model, cwl, cwr, lt, rt, s)
  Nl = length(unique(cwl));
  nl = pi * robot_model.d * lt ./ s;
  nl_fit_coeff = polyfit(cwl, nl, min(Nl-1, 5));
  nl_fit = @(cw)(polyval(nl_fit_coeff, cw));
  Nr = length(unique(cwr));
  nr = pi * robot_model.d * rt ./ s;
  nr_fit_coeff = polyfit(cwr, nr, min(Nr-1, 5));
  nr_fit = @(cw)(polyval(nr_fit_coeff, cw));
end
