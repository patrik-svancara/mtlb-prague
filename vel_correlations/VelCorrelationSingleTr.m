function [mcorr,wcorr] = VelCorrelationSingleTr(tr,tsep,gr)
% Velocity fluctuation autocorrelation.
% Mean flow is subtracted with respect to the position of data points.

% remove mean flow
tr.flvel = SubtrFromTr(tr,gr,'mean');
% remove mean flow by interpolation - NOT USED
% tr.flvel = SubtrFromTrInterpol(tr,gr);

% check if mean flow removal was successful
if any(any(isnan(tr.flvel)))
    
    mcorr = NaN;
    wcorr = NaN;
    return

% check trajectory length
elseif (tr.length <= tsep)
    
    mcorr = NaN;
    wcorr = NaN;
    return
    
end

% memory preallocation
corr = zeros(tr.length - tsep,2);

% correlation values
for i = 1:(tr.length - tsep)
    
    corr(i,:) = tr.flvel(i+tsep,:).*tr.flvel(i,:);
    
end

% mean correlation coefficient
mcorr = mean(corr,1);

% weight used for statistical mean
wcorr = size(corr,1);

end