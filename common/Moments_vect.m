function [mom] = Moments(h)
% Calculation of statistical moments for a given n-column vector
% avg = mean value
% rms = RMS value
% sdev = standard deviation
% skew = skewness
% flat = flatness

% memory preallocation
mom = zeros(6,size(h,2));

% calculation is done separately for each data column
for i = 1:size(h,2)

    n = length(h(:,i));
    
    avg = mean(h(:,i));

    rms = sqrt(sum(h(:,i).*h(:,i))/n);

    mom2 = sum((h(:,i)-avg).^2)/n;
    mom3 = sum((h(:,i)-avg).^3)/n;
    mom4 = sum((h(:,i)-avg).^4)/n;

    sdev = sqrt(mom2);
    skew = mom3/mom2^(3/2);
    flat = mom4/mom2^2;

    mom(:,i) = [n avg rms sdev skew flat];
end

end