function [velstats,velpdf,veldata] = VelStatsSingleMov(mov,dim)
% Velocity statistics for a single movie. Works in any dimension.
% Returns statistical moments and velocity PDF (mm/s and normalized).

% add dependencies
addpath('../');

% handle dimensionality
if nargin == 1
    dim = 3; % we usually work in 2D (+ velocity magnitude)
end

EMPTY = zeros(1,dim);
NULL = NaN*ones(1,dim);

% memory preallocation for raw data
velsize = sum([mov.tr(:).vlength]);

% velstats struct initialiaztion
velstats = struct('pts',EMPTY,'mean',EMPTY,'rms',EMPTY,'std',EMPTY,'skew',EMPTY,'flat',EMPTY);

% velpdf struct initialization
velpdf = struct('raw',[],'norm',[]);

% no valid velocity values are found
if (velsize == 0)
    
    velstats.pts = EMPTY;
    velstats.mean = NULL;
    velstats.rms = NULL;
    velstats.std = NULL;
    velstats.skew = NULL;
    velstats.flat = NULL;
    
    velpdf.raw = NaN;
    velpdf.norm = NaN;
    
    veldata = NaN;

% some velocity values are found
else
    
    % memory preallocation
    veldata = zeros(velsize,dim);
    
    % init of data indices
    velind = 1;
    
    % loading data into a single array
    for t = 1:length(mov.tr)
        
        if ~(mov.tr(t).vlength == 0)
            veldata(velind:(velind + mov.tr(t).vlength-1),:) = mov.tr(t).vel;
            velind = velind + mov.tr(t).vlength; 
        end
    end
    
    % statistical moments (points,mean,rms,stdev,skew,flat)
    velstats = Moments(veldata);
    
    % PDF computation - raw data
    velpdf.raw = GetPdf(veldata);
    
    % PDF computation - normalized data
    veldatanorm = (veldata - velstats.mean')./velstats.std';
    velpdf.norm = GetPdf(veldatanorm);
    
end

end