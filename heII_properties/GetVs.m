function [vs] = GetVs(temp,flux)
% Returns superfluid component velocity(ies) 'vns' for given temperature(s) 'temp' and heat flux(es) 'flux'.
% Data obtained from Hepak and linearly interpolated.

load('hepak.mat');

% vs in mm/s
vs = GetVn(temp,flux).*(interp1(hepak.temp,hepak.frN,temp)./interp1(hepak.temp,hepak.frS,temp));