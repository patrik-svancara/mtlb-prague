function [velstats,velpdfmap,veldata] = VelMapSingleMov(mov)
% 2-D velocity map for a single movie.
% Returns statistical moments and velocity PDF (mm/s and normalized).

% add dependencies
addpath('../');

% memory preallocation for raw data
velsize = sum([mov.tr(:).vlength]);

% velstats struct initialiaztion
velstats = struct('pts',zeros(1,3),'mean',zeros(1,3),'rms',zeros(1,3),...
    'std',zeros(1,3),'skew',zeros(1,3),'flat',zeros(1,3));

% velpdf struct initialization
velpdfmap = struct('raw',[],'norm',[]);

% no valid velocity values are found
if (velsize == 0)
    
    velstats.pts = [0 0 0];
    velstats.mean = NaN*ones(1,3);
    velstats.rms = NaN*ones(1,3);
    velstats.std = NaN*ones(1,3);
    velstats.skew = NaN*ones(1,3);
    velstats.flat = NaN*ones(1,3);
    
    velpdfmap.raw = NaN;
    velpdfmap.norm = NaN;

% some velocity values are found
else
    
    % memory preallocation
    veldata = zeros(velsize,3);
    
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
    
    % 2-D histogram computation - raw data
    velpdfmap.raw = GetPdfMap(veldata);
    
    % PDF computation - normalized data
    veldatanorm = (veldata - velstats.mean')./velstats.std';
    velpdfmap.norm = GetPdf(veldatanorm);
    
end

end