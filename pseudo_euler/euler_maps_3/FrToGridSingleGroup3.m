function [gr] = FrToGridSingleGroup3(group,xbins,ybins,movf)

% add deps
addpath('../../common');

% prepare output folder
OUT_FOLDER_TEMPLATE = '../../../results/euler_res/%s/';
outfolder = sprintf(OUT_FOLDER_TEMPLATE,group);
if exist(outfolder,'dir') == 0
    
    mkdir(outfolder)
    
end

% output files template
OUT_FIG_TEMPLATE = [outfolder 'map_bins%dx%d_%s_%s.png'];
OUT_DATA_TEMPLATE = [outfolder 'map_bins%dx%d_data_%s.mat'];

if nargin < 4

    % load data
    MOVF_TEMPLATE = '../../../results/tracks/movfr_%s.mat';
    load(sprintf(MOVF_TEMPLATE,group),'movf');
    
end

% set up an empty gr structure (# of edges is one more than # of bins)
vxrange = linspace(0,movf(1).caminfo.resx*movf(1).scfactor/1e3,xbins+1);
vyrange = linspace(0,movf(1).caminfo.resy*movf(1).scfactor/1e3,ybins+1);

gr = GridInit3(vxrange,vyrange);

% init progress bar
fprintf('Processing run %03d/%03d',0,length(movf));

for m = 1:length(movf)
    
    % progress bar
    fprintf('\b\b\b\b\b\b\b%03d/%03d',m,length(movf));
    
    for f = 1:length(movf(m).fr)
        
        % add frame to grid if it contains points
        if movf(m).fr(f).pts > 0
            
            gr = AddFrToGrid3(gr,movf(m).fr(f));
            
        end
        
    end
        
end

% message to the user
fprintf(' done.\nSaving results ...');

% transform grid to have only mean values
gr = GridStats3(gr);

% plot mean velocity and acceleration maps
ITEMS = ["Xvel" "Yvel" "Avel" "Xacc" "Yacc" "Aacc" "pts"];
TITLES = ["Horizontal velocity [mm/s]" "Vertical velocity [mm/s]" "Absolute velocity [mm/s]"...
    "Horizontal acceleration [mm/s^2]" "Vertical acceleration [mm/s^2]"...
    "Absolute acceleration [mm/s^2]" "Points [-]"]; 

for i = 1:length(ITEMS)
    
    eval(sprintf("imagesc(gr.Xcenters([1 end]),gr.Ycenters([1 end]),gr.%s');",ITEMS(i)));
    axis xy; cbar = colorbar;
    
    xlabel('Horizontal dimension [mm]');
    ylabel('Vertical dimension [mm]');
    
    eval(sprintf("ylabel(cbar, '%s');",TITLES(i)));
    title(group,'Interpreter','none');
    
    eval(sprintf("print(gcf,'-dpng',sprintf(OUT_FIG_TEMPLATE,xbins,ybins,'%s',group));",ITEMS(i)));
    
end

% save the data
save(sprintf(OUT_DATA_TEMPLATE,xbins,ybins,group),'gr');

% message to the user
fprintf(' done.\n');

end