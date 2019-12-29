function [velrms,accrms] = GetRMSDiffSingleGroup(group,oldparamind,newparamind)

% init result struct
velrms = struct('rms',[0 0 0],'pts',0);
accrms = struct('rms',[0 0 0 0 0],'pts',0);


% load movies into memory
MOVTEMPLATE = '../../results/tracks/conv_%s/mov_%s_gauss%d.mat';
oldmov = load(sprintf(MOVTEMPLATE,group,group,oldparamind));
newmov = load(sprintf(MOVTEMPLATE,group,group,newparamind));



% for each movie
for m = 1:length(newmov.mov)
    
    % get rms values for one movie
    [movvelrms,movaccrms] = GetRMSDiffSingleMov(oldmov.mov(m),newmov.mov(m));
    
    % convert rms to the square sum
    movvelrms.rms = movvelrms.rms.^2.*movvelrms.pts;
    movaccrms.rms = movaccrms.rms.^2.*movaccrms.pts;
    
    % update global stats
    velrms.rms = velrms.rms + movvelrms.rms;
    accrms.rms = accrms.rms + movaccrms.rms;
    
    velrms.pts = velrms.pts + movvelrms.pts;
    accrms.pts = accrms.pts + movaccrms.pts;
    
end

% calculate actual rms values
velrms.rms = sqrt(velrms.rms/velrms.pts);
accrms.rms = sqrt(accrms.rms/accrms.pts);

end