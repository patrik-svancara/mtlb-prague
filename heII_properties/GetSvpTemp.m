function [temp] = GetSvpTemp(torr)
% Returns temperature(s) 'temp' for the given SVP pressure(s) 'torr'.
% Data obtained from Hepak and linearly interpolated.

load('hepak.mat');

temp = interp1(hepak.torr,hepak.temp,torr);

% Returns NaN if temp is out of range of the available data (1.0 K - 2.5 K)
outRng = ~(1.0 <= temp & temp <= 2.5);

temp(outRng) = nan;

end