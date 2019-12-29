function [gamma] = GetGammaBarenghi(temp)
% Returns gamma values (in s/mm) for the given temperatures.
% Data obtained from [Sergeev, Barenghi, Kivotides (2006)]
% and linearly interpolated.

load('gamma_barenghi.mat','gamma2');

% returns NaN if temp is out of range of the available data (1.22 K - 2.1 K)
outRng = ~(1.22 <= temp & temp <= 2.1);
gamma(outRng) = nan;

inRng = ~outRng;

% returns interpolated gamma in the correct temp range
gamma(inRng) = interp1(gamma2(:,1),gamma2(:,2),temp(inRng));

end
