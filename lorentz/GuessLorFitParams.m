function [p] = GuessLorFitParams(freq,volt)
% Function returns reasonable guess of the initial fitting parameter vector
% Author: PŠ, adapted from LV code of DS

% max & min amplitudes and frequencies
[maxvolt,maxind] = max(volt);
maxvoltfreq = freq(maxind);

[minvolt,~] = min(volt);

% background intereceipt and linear slope
p(1) = minvolt;
p(2) = 0;

% half width estimate
[sortvolt,sortind] = unique(volt);
hwidth = abs(maxvoltfreq - freq(interp1(sortvolt,sortind,mean([maxvolt minvolt]),'nearest')));

% peak amplitude and width
p(3) = (2*hwidth)^2*abs(maxvolt - minvolt);
p(4) = (2*hwidth)^2;

% resonant frequency
p(5) = maxvoltfreq^2;

% phase
p(6) = 0;

end

