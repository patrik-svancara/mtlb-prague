function [filt] = HypeClassTool(vel,acc,slowp,fastp)

% define limiting hyperbolae
slowhype = @(vel,acc) ((vel-slowp(1))./slowp(2)).^2 - ((acc-slowp(3))./slowp(4)).^2;
fasthype = @(vel,acc) ((vel-fastp(1))./fastp(2)).^2 - ((acc-fastp(3))./fastp(4)).^2;

% evaluate parabolas and look for values > 1 (inside the hyperbola)
hypefilt = [slowhype(vel,acc) fasthype(vel,acc)] > 1;

% eliminate phantom (pair) hyperbolae by looking at velocities

hypephantom = [vel <= fastp(1)+2*fastp(2) vel >= slowp(1)-2*fastp(2)];

hypeval = and(hypefilt,hypephantom);

% total filter coding
filt(hypeval(:,1)) = -2;
filt(hypeval(:,2)) = 2;

% transition detection - look for positive / negative accelerations
accval = [(acc >= 0) (acc < 0)];

transval = and(~or(hypeval(:,1),hypeval(:,2)),accval);

filt(transval(:,1)) = -1;
filt(transval(:,2)) = 1;

% check
if any(filt == 0)
    warning('Undetected data points!');
end

end