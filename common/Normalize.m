function [norm] = Normalize(data,opt)
% Mormalizes 2D data (data sets in columns).
% Default behavior 'def': remove mean and divide by standard deviation.
% Keep nonzero mean 'kmean': divide by standard deviation only.

if nargin == 1
    
    opt = 'def';
    
end

% (1) Calculate mean and standard deviation
mdata = mean(data,1);
sdata = std(data,0,1);

% (2) Normalize
switch opt
    
    case 'def'
        norm = (data - mdata)./sdata;

    case 'kmean'
        norm = data./sdata;
        
end

end