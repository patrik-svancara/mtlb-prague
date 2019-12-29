function [mom] = Moments(data)
% Returns statistical moments struct for a given n-column data vector

% number of columns
ncols = size(data,2);

% struct initialization
mom = struct('pts',zeros(ncols,1),'mean',zeros(ncols,1),...
    'rms',zeros(ncols,1),'std',zeros(ncols,1),'skew',zeros(ncols,1),...
    'flat',zeros(ncols,1),'min',zeros(ncols,1),'max',zeros(ncols,1));

% spearate calculation for each column (for clarity)
for c = 1:ncols

    mom.pts(c) = length(data(:,c));
    
    mom.mean(c) = mean(data(:,c));

    mom.rms(c) = sqrt(mean(data(:,c).^2));

    mom2 = mean((data(:,c)-mom.mean(c)).^2);
    mom3 = mean((data(:,c)-mom.mean(c)).^3);
    mom4 = mean((data(:,c)-mom.mean(c)).^4);

    mom.std(c) = sqrt(mom2);
    
    mom.skew(c) = mom3/(mom2^(3/2));
    mom.flat(c) = mom4/(mom2^2);
    
    mom.min(c) = min(data(:,c));
    mom.max(c) = max(data(:,c));
    
end

end