function [mcorr,wcorr] = NormVelCorrelationSingleTr(tr,tsep)
% Velocity autocorrelation function. Assumes velocites are normalized.

% check trajectory length
if(tr.length <= tsep)
    
    mcorr = NaN*ones(1,size(tr.vel,2));
    wcorr = 0;
    return
    
end

% memory preallocation
corr = zeros(tr.length - tsep,size(tr.vel,2));

% correlation values
for i = 1:(tr.length - tsep)
    
    corr(i,:) = tr.vel(i+tsep,:).*tr.vel(i,:);
    
end

% mean correlation coefficient
mcorr = mean(corr,1);

% weight used for statistical mean
wcorr = size(corr,1);

end