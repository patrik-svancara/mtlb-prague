function [mov] = InterpolateLocThetaSingleGroup(group,frwin)
% Interpolate the local value of theta parameter for the given group.
% (1) Loads mov, movfr and the adequate mean T sequence for the given group
% (2) Interpolates theta values at particle positions by using movfr structure.
% (3) Local theta is then reconstructed in the mov structure.
% (4) Both mov and movfr data are then saved

% message to the user
fprintf('Loading data...\n');

% movies
MOVFRTEMPLATE = '../../results/tracks/movfr_%s.mat';
load(sprintf(MOVFRTEMPLATE,group),'movf');

MOVTEMPLATE = '../../results/tracks/mov_%s.mat';
load(sprintf(MOVTEMPLATE,group),'mov');

% theta sequence (nromal time window)
SEQTEMPLATE = '../../results/theta_res/mseqtheta_r1x5m115x101t%d_%s.mat';
load(sprintf(SEQTEMPLATE,frwin,group),'mseqtheta');
% interpolate for sliding time window sequence
slmseqtheta = SlseqByInterpolation(mseqtheta,frwin);

% grid
load('../../results/mygrid.mat');

% for all the movies
for m = 1:length(movf)
    
    % message to the user
    fprintf('Processing movie %d/%d\n',m,length(movf));
    
    % for all frames
    for f = 1:length(movf(m).fr)
        
        if movf(m).fr(f).pts > 0
            
            % find interpolated values
            movf(m).fr(f).ltheta = interp2(gr.posx,gr.posy,...
                reshape(slmseqtheta(f,:,:),gry,grx),...
                movf(m).fr(f).pos(:,1),movf(m).fr(f).pos(:,2));
            
        end
        
    end
    
    % reconstruct loc theta back to the mov structure
    for t = 1:length(mov(m).tr)
        
        for i = 1:mov(m).tr(t).length
            
            fi = (movf(m).fr(mov(m).tr(t).fr(i)).tr == t);
            mov(m).tr(t).ltheta(i) = movf(m).fr(mov(m).tr(t).fr(i)).ltheta(fi);
            
        end
    end
    
end

% message to the user
fprintf('Saving data...\n');

% save the results
save(sprintf(MOVFRTEMPLATE,group),'movf');
save(sprintf(MOVTEMPLATE,group),'mov');
