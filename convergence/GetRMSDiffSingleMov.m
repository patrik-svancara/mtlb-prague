function [velrms,accrms] = GetRMSDiffSingleMov(oldmov,newmov)
% Returns velrms and accrmls structures (RMS value and number of points)
% for a given pair of movies.

% struct initialization
velrms = struct('rms',[0 0 0],'pts',0);
accrms = struct('rms',[0 0 0 0 0],'pts',0);

% for all tracks
for t = 1:length(newmov.tr)
    
    [veldiff,accdiff] = GetRMSDiffSingleTr(oldmov.tr(t),newmov.tr(t));
    
    if ~isnan(veldiff)
    
        velrms.rms = velrms.rms + sum(veldiff.^2,1);
        velrms.pts = velrms.pts + size(veldiff,1);
    
    end
    
    if ~isnan(accdiff)
    
        accrms.rms = accrms.rms + sum(accdiff.^2,1);
        accrms.pts = accrms.pts + size(accdiff,1);
        
    end
    
end

% calculate actual rms values
velrms.rms = sqrt(velrms.rms/velrms.pts);
accrms.rms = sqrt(accrms.rms/accrms.pts);

end
    
    
