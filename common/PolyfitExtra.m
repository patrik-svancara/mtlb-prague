function [fit] = PolyfitExtra(x,y,dg,sind,eind)
% Polynomial fit with enhanced functionality:
% - user-defined polynomial degree dg;
% - omits NaN values;
% - manual setting of the start and end indices (optional);
% Returns fit structure:
% - fit.params: fit parameters (suitable for polyval)
% - fit.err: errors of the parameters
% - fit.range: index range selected for fitting

% memory prealloc
fit = struct;

% handle optional parameters
if nargin == 3
    
    sind = 1;
    eind = size(x,1);
    
end

% manual filter
xfit = x(sind:eind);
yfit = y(sind:eind);

fit.range = [sind eind];

% remove NaN
nanflag = ~isnan(yfit);

xfit = xfit(nanflag);
yfit = yfit(nanflag);

% polynomial fit
[fit.pars,fitmat] = polyfit(xfit,yfit,dg);

% estimate of fit error (MAGIC)
% https://stats.stackexchange.com/questions/56596/finding-uncertainty-in-coefficients-from-polyfit-in-matlab
fit.err = sqrt(diag(inv(fitmat.R)*inv(fitmat.R')).*fitmat.normr.^2./fitmat.df);

end