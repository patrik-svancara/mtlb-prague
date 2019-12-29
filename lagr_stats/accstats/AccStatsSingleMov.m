function [accstats,accpdf,accdata] = AccStatsSingleMov(mov)
% Acceleration statistics for a single movie.
% Returns statistical moments and acceleration PDF (mm/s and normalized).

ACCDIM = 3;
EMPTY = zeros(1,ACCDIM);
NULL = NaN*ones(1,ACCDIM);

% add dependencies
addpath('../');

% memory preallocation for raw data
accsize = sum([mov.tr(:).alength]);

% accstats struct initialiaztion
accstats = struct('pts',EMPTY,'mean',EMPTY,'rms',EMPTY,'std',EMPTY,'skew',EMPTY,'flat',EMPTY);

% accpdf struct initialization
accpdf = struct('raw',[],'norm',[]);

% no valid acceleration values are found
if (accsize == 0)
    
    accstats.pts = EMPTY;
    accstats.mean = NULL;
    accstats.rms = NULL;
    accstats.std = NULL;
    accstats.skew = NULL;
    accstats.flat = NULL;
    
    accpdf.raw = NaN;
    accpdf.norm = NaN;
    
    accdata = NaN;

% some acceleration values are found
else
    
    % memory preallocation
    accdata = zeros(accsize,ACCDIM);
    
    % init of data indices
    accind = 1;
    
    % loading data into a single array
    for t = 1:length(mov.tr)
        
        if ~(mov.tr(t).alength == 0)
            accdata(accind:(accind + mov.tr(t).alength-1),:) = mov.tr(t).acc;
            accind = accind + mov.tr(t).alength; 
        end
    end
    
    % remove NaN values (e.g. when there is zero velocity vector)
    accdata = RemoveNaN(accdata);
    
    % statistical moments (points,mean,rms,stdev,skew,flat)
    accstats = Moments(accdata);
    
    % PDF computation - raw data
    accpdf.raw = GetPdf(accdata);
    
    % PDF computation - normalized data
    accdatanorm = (accdata - accstats.mean')./accstats.std';
    accpdf.norm = GetPdf(accdatanorm);
    
end

end