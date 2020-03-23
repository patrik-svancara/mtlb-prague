function [fs] = FitSingleFS(fs,rawfit)
% Main function to fit single two-component frequency sweep with two-component Lorentzian peak

% memory prealloc
sz = size(fs.abs.volt);
fs.cln.volt = zeros(sz);
fs.cln.voltfit = zeros(sz);
fs.shift.volt = zeros(sz);
fs.shift.voltfit = zeros(sz);

fs.fit(1:2) = struct('fitp',zeros(1,7),'fitplbl',strings(1,7),'msg',"");


% function handle
fitfunc = {@LorX @LorY};

% upscale measured voltages for better performance of the fitting algorithm
SC = 1e6;

% two-component fit if not provided externally
if nargin < 2
    rawfit = LorXYFit(fs.freq,fs.abs.volt*SC);
end

% process fit results
for i = 1:2
    
    % downscale output parameters
    rawfit(i).outp = rawfit(i).outp.*[1/SC 1/SC 1/SC 1 1 1];
    
    % fit message
    fs.fit(i).msg = rawfit(i).fitmsg;
    
    % final set of parameters:
    % background
    fs.fit(i).fitp(1) = rawfit(i).outp(1);
    fs.fit(i).fitplbl(1) = "Background interceipt (Vrms)";
    
    fs.fit(i).fitp(2) = rawfit(i).outp(2);
    fs.fit(i).fitplbl(2) = "Background slope (Vrms/Hz)";
    
    % amplitude (Vrms)
    fs.fit(i).fitp(3) = rawfit(i).outp(3)/rawfit(i).outp(4);
    fs.fit(i).fitplbl(3) = "Peak amplitude (Vrms)";
    
    % resonant frequency (Hz)
    fs.fit(i).fitp(4) = sqrt(rawfit(i).outp(5));
    fs.fit(i).fitplbl(4) = "Resonance frequency (Hz)";
    
    % peak width (Hz)
    fs.fit(i).fitp(5) = sqrt(rawfit(i).outp(4));
    fs.fit(i).fitplbl(5) = "Peak width (Hz)";
    
    % Q-factor
    fs.fit(i).fitp(6) = fs.fit(i).fitp(4)/fs.fit(i).fitp(5);
    fs.fit(i).fitplbl(6) = "Q-factor (-)";
    
    % phase
    fs.fit(i).fitp(7) = rawfit(i).outp(6)*180/pi;
    fs.fit(i).fitplbl(7) = "Phase (deg)";
    
    % evaluate fit
    fs.abs.voltfit(:,i) = feval(fitfunc{i},rawfit(i).outp,fs.freq);
    
    % remove background signal
    fs.cln.volt(:,i) = fs.abs.volt(:,i) - feval(@(p,x)p(1) + p(2)*x,rawfit(i).outp(1:2),fs.freq);
    
    % evaluate fit without background signal
    fs.cln.voltfit(:,i) = feval(fitfunc{i},rawfit(i).outp.*[0 0 1 1 1 1],fs.freq);
    
    % evaluate fit with zero phase shift
    fs.shift.voltfit(:,i) = feval(fitfunc{i},rawfit(i).outp.*[0 0 1 1 1 0],fs.freq);
    
end

% circle fit for phase-shifting
cfit = FitCircle(fs.cln.volt);

% center data to the origin
volt = fs.cln.volt - cfit(1:2);

% rotate by the angle estimated from the origin position
volt = volt(:,1) + 1j*volt(:,2);
phi = atan2(cfit(2),cfit(1));

volt = volt*exp(-phi*1j);

volt = [real(volt) imag(volt)];

% reverse initial shift, should be only in the x-direction
% save data into structure
fs.shift.volt = volt + [sqrt(cfit(1)^2 + cfit(2)^2) 0];
    
end