function [vns] = GetVns(temp,flux)
% Returns counterflow velocity(ies) 'vns' for given temperature(s) 'temp' and heat flux(es) 'flux'.
% Data obtained from Hepak and linearly interpolated.

load('hepak.mat');

% conversion to mm/s
TOMMPS = 1000;

vns = flux./(interp1(hepak.temp,hepak.rhoS,temp).*interp1(hepak.temp,hepak.entropy,temp).*temp).*TOMMPS;