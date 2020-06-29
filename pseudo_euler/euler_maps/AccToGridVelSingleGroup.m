function [gr] = AccToGridVelSingleGroup(group,xbins,ybins,mov)

% add deps
addpath('../../common');

% prepare output folder
OUT_FOLDER_TEMPLATE = '../../../results/euler_res/%s/';
outfolder = sprintf(OUT_FOLDER_TEMPLATE,group);
if exist(outfolder,'dir') == 0
    
    mkdir(outfolder)
    
end

% output file template
OUT_DATA_TEMPLATE = [outfolder 'grid_vel_acc_data_%s.mat'];

if nargin < 4

    % load data
    MOV_TEMPLATE = '../../../results/tracks/mov_%s.mat';
    load(sprintf(MOV_TEMPLATE,group),'mov');
    
end

% init grid structure for accelerations
gr = InitGridAcc(xbins,ybins);

% init progress bar
fprintf('Processing run %03d/%03d',0,length(mov));

for m = 1:length(mov)
    
    % update progress bar
    fprintf('\b\b\b\b\b\b\b%03d/%03d',m,length(mov));
    
    for t = 1:length(mov(m).tr)
        
        % add trajectory to grid if it contains points
        if mov(m).tr(t).length > 0
            
            % position-based grid
            gr = AccFrToGridVel(gr,mov(m).tr(t).vel,mov(m).tr(t).acc);
            
        end
        
    end
        
end

% update progress
fprintf(' done.\nSaving results ...');

% process raw grid data
gr = StatsGridAcc(gr);

% save data
save(sprintf(OUT_DATA_TEMPLATE,group),'gr');

% update progress
fprintf(' done.\n');

end