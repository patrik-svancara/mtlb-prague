function [velstats,velpdf,veldata] = VelStatsFlagSingleMovf(movf,flagval,nbins)
% Velocity statistics for a single movie (in movf format), by considering data where flag = flagval.
% Returns statistical moments and velocity PDF (mm/s and normalized).
% Assumes data are flagged in 1D movf.fr.flag vector.

% set default number of bins
if nargin == 2
    
    nbins = 100;
    
end

% add dependencies
addpath('../');

% memory preallocation
velsize = 0;

for f = 1:length(movf.fr)
    velsize = velsize + sum(movf.fr(f).flag == flagval);
end

% velstats struct initialiaztion
velstats = struct('pts',[0 0 0],'mean',[0 0 0],'rms',[0 0 0],'std',[0 0 0],'skew',[0 0 0],'flat',[0 0 0]);

% velpdf struct initialization
velpdf = struct('raw',[],'norm',[]);

% no valid velocity values are found
if (velsize == 0)
    
    velstats.pts = [0 0 0];
    velstats.mean = NaN*ones(1,3);
    velstats.rms = NaN*ones(1,3);
    velstats.std = NaN*ones(1,3);
    velstats.skew = NaN*ones(1,3);
    velstats.flat = NaN*ones(1,3);
    
    velpdf.raw = NaN;
    velpdf.norm = NaN;
    
    veldata = [ ];

% some velocity values are found
else
    
    % memory preallocation
    veldata = zeros(velsize,3);
    
    % init of data indices
    velind = 1;
    
    % loading data into a single array
    for f = 1:length(movf.fr)
        
        if ~(movf.fr(f).pts == 0)
            veldata(velind:(velind + sum(movf.fr(f).flag == flagval)-1),:) = movf.fr(f).vel((movf.fr(f).flag == flagval),:);
            velind = velind + sum(movf.fr(f).flag == flagval); 
        end
    end
    
    % statistical moments (points,mean,rms,stdev,skew,flat)
    velstats = Moments(veldata);
    
    % PDF computation - raw data
    velpdf.raw = GetPdf(veldata,nbins);
    
    % PDF computation - normalized data
    veldatanorm = (veldata - velstats.mean')./velstats.std';
    velpdf.norm = GetPdf(veldatanorm,nbins);
    
end

end