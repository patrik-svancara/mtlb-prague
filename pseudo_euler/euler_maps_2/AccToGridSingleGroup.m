function [gr] = AccToGridSingleGroup(group,camfps)

% fixed constants
VXBINS = 21;
VYBINS = 21;

ACCFILT = [5 10];

% add deps4
addpath('../../common');

% prepare output folder
OUT_FOLDER_TEMPLATE = '../../../results/euler_res/%s/';
outfolder = sprintf(OUT_FOLDER_TEMPLATE,group);
if exist(outfolder,'dir') == 0
    
    mkdir(outfolder)
    
end

% output files template
OUT_FIG_TEMPLATE = [outfolder 'velspace_map_bin20x20_%s_%s.png'];
OUT_DATA_TEMPLATE = [outfolder 'velspace_map_bin20x20_data_%s.mat'];

% load data
MOV_TEMPLATE = '../../../results/tracks/mov_%s.mat';
load(sprintf(MOV_TEMPLATE,group),'mov');

STATS_TEMPLATE = '../../../results/lagr_res/%1$s/velstat_data_%1$s.mat';
load(sprintf(STATS_TEMPLATE,group),'stats');

% set up an empty gr structure
vxrange = linspace(stats(end).velstats.mean(1) - 3*stats(end).velstats.std(1),stats(end).velstats.mean(1) + 3*stats(end).velstats.std(1),VXBINS);
vyrange = linspace(stats(end).velstats.mean(2) - 3*stats(end).velstats.std(2),stats(end).velstats.mean(2) + 3*stats(end).velstats.std(2),VYBINS);

gr = GridInit2(vxrange,vyrange);

% init progress bar
fprintf('Processing run %03d/%03d',0,length(mov));

% calculate accelerations & add them to gr structure
for m = 1:length(mov)
    
    % progress bar
    fprintf('\b\b\b\b\b\b\b%03d/%03d',m,length(mov));
    
    for t = 1:length(mov(m).tr)
        
        % calculate acceleration
        [mov(m).tr(t).acc,mov(m).tr(t).alength] = AccelerationGauss(mov(m).tr(t).pos,1/camfps,ACCFILT);
        
        mov(m).tr(t) = AccelerationAbsolute(mov(m).tr(t));
        
        if mov(m).tr(t).alength > 0
            
            gr = AddFrToGrid2(gr,mov(m).tr(t).vel(1+ACCFILT(2):end-ACCFILT(2),:),mov(m).tr(t).acc);
            
        end
        
    end
end

% message to the user
fprintf(' done.\nSaving results ...');

% acceleration mean, std and rms
gr = GridStats2(gr);

% plot mYacc + acc direction
[grx,gry] = meshgrid(gr.Xcenters,gr.Ycenters);
QUIV_SCALE = 3; % arrow scaling coefficient

imagesc(gr.Xcenters([1 end]),gr.Ycenters([1 end]),gr.mYacc'); axis xy; cbar = colorbar;
hold on;
quiver(grx,gry,gr.mXacc',gr.mYacc',QUIV_SCALE,'Color','w');
hold off;

xlabel('Horizontal velocity [mm/s]');
ylabel('Vertical velocity [mm/s]');
ylabel(cbar, 'Mean vertical acceleration [mm/s^2]');
title(group);

print(gcf,'-dpng',sprintf(OUT_FIG_TEMPLATE,'mYacc',group));

% save the data
save(sprintf(OUT_DATA_TEMPLATE,group),'gr');

% message to the user
fprintf(' done.\n');

end
