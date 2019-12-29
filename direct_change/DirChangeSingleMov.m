function [mtheta,wtheta,hcts] = DirChangeSingleMov(mov,hedges,tsep)
% Returns mean theta and its statistical wieght for a single movie.
% Returns also histogram counts for a histogram specified by hedges.

% dependencies
addpath('../common/');

% memory prealloc
hcts = zeros(1,length(hedges)-1);
mthetas = zeros(length(mov.tr),1);
wthetas = mthetas;

% through all the tracks
for t = 1:length(mov.tr)
    
    theta = DirChangeSingleTr(mov.tr(t),tsep);
    
    % check if we get NaN
    if isnan(theta)
        
        mthetas(t) = NaN;
        wthetas(t) = NaN;
        
    else
        
        mthetas(t) = mean(theta);
        wthetas(t) = sum(theta);
        
        hcts = hcts + histcounts(theta/pi,hedges);
        
    end
    
end

% wieghted movie mean
mthetas = RemoveNaN(mthetas);
wthetas = RemoveNaN(wthetas);

mtheta = sum(mthetas.*wthetas)/sum(wthetas);
wtheta= sum(wthetas);

end