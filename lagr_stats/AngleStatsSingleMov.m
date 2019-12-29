function [astats,apdf,adata] = AngleStatsSingleMov(mov)
% Angle statistics for a single movie.
% Returns statistical moments and PDF (mm/s and normalized).

% add dependencies
addpath('../');

dim = 1;
EMPTY = zeros(1,dim);
NULL = NaN*ones(1,dim);

% memory preallocation for raw data
velsize = sum([mov.tr(:).vlength]);

% anglestats struct initialiaztion
astats = struct('pts',EMPTY,'mean',EMPTY,'rms',EMPTY,'std',EMPTY,'skew',EMPTY,'flat',EMPTY);

% anglepdf struct initialization
apdf = struct('raw',[],'norm',[]);

% no valid velocity values are found
if (velsize == 0)
    
    astats.pts = EMPTY;
    astats.mean = NULL;
    astats.rms = NULL;
    astats.std = NULL;
    astats.skew = NULL;
    astats.flat = NULL;
    
    apdf.raw = NaN;
    apdf.norm = NaN;
    
    adata = NaN;

% some velocity values are found
else
    
    % memory preallocation
    adata = zeros(velsize,dim);
    
    % init of data indices
    velind = 1;
    
    % loading data into a single array
    for t = 1:length(mov.tr)
        
        if ~(mov.tr(t).vlength == 0)
            adata(velind:(velind + mov.tr(t).vlength-1),:) = mov.tr(t).angle;
            velind = velind + mov.tr(t).vlength; 
        end
    end
    
    % statistical moments (points,mean,rms,stdev,skew,flat)
    astats = Moments(adata);
    
    % PDF computation - raw data
    apdf.raw = GetPdf(adata);
    
end

end