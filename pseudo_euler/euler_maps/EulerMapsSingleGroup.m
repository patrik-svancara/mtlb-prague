function [eumap] = EulerMapsSingleGroup(group,nbins,fovsize)
% Returns pseudo Euler map of particle kinematics for a single group.
% Plots maps of velocity mean and standard deviation.

% prepare output folder
RESTEMPLATE = '../../../results/euler_res/%s/';
outfolder = sprintf(RESTEMPLATE,group);
if exist(outfolder,'dir') == 0
    
    mkdir(outfolder)
    
end

% outfile template
OUTFIGTEMPLATE = [outfolder 'eumap_%s_%s.png'];
OUTDATATEMPLATE = [outfolder 'eumap_data_%s.mat'];

% load data
MOVFRTEMPLATE = '../../../results/tracks/movfr_%s.mat';
load(sprintf(MOVFRTEMPLATE,group));

% preallocation of eumap struct (for each movie + mean value)
for m = 1:length(movf)
        
    eumap(m).gr = struct([]);
    eumap(m).name = movf(m).name;
    eumap(m).caminfo = movf(m).caminfo;
        
end
eumap(end+1).gr = struct([]);

% initialization of the global grid
grtot = GridInit(nbins,fovsize);

for m = 1:length(movf)
    
    % message to the user
    fprintf('Processing run %d/%d\n',m,length(movf));
    
    % initialization of the local grid
    eumap(m).gr = GridInit(nbins,fovsize);
    
    for f = 1:length(movf(m).fr)
        
        eumap(m).gr = AddFrameToGrid(eumap(m).gr,movf(m).fr(f));
        
    end
    
    % merge with total grid
    grtot = MergeGrids(grtot,eumap(m).gr);
    
    % figure to the user
    [~,vy,~,~,~] = GrToMaps(grtot);
    imagesc([0 fovsize(1)],[0 fovsize(2)],vy);
    axis xy;
    c = colorbar;
    caxis('auto');
    set(get(c,'Label'),'String','Vertical velocity [mm/s]');
    set(c.Label,'FontSize',11);
    xlabel('Horizontal position [mm]');
    ylabel('Vertical position [mm]');
    title(sprintf('Run %d/%d',m,length(movf)));
    
    pause(0.5);
    
end

% grtot to last eumap struct
eumap(end).gr = grtot;

% make & save figures
[vx,vy,sqvx,sqvy,pts] = GrToMaps(grtot);

imagesc([0 fovsize(1)],[0 fovsize(2)],vy);
axis xy;
c = colorbar;
caxis('auto');
set(get(c,'Label'),'String','Vertical velocity [mm/s]');
set(c.Label,'FontSize',11);
xlabel('Horizontal position [mm]');
ylabel('Vertical position [mm]');
title(group,'interpreter','none');

pause(0.5);
print(gcf,'-dpng',sprintf(OUTFIGTEMPLATE,'vy',group));

imagesc([0 fovsize(1)],[0 fovsize(2)],vx);
axis xy;
c = colorbar;
caxis('auto');
set(get(c,'Label'),'String','Horizontal velocity [mm/s]');
set(c.Label,'FontSize',11);
xlabel('Horizontal position [mm]');
ylabel('Vertical position [mm]');
title(group,'interpreter','none');

pause(0.5);
print(gcf,'-dpng',sprintf(OUTFIGTEMPLATE,'vx',group));

imagesc([0 fovsize(1)],[0 fovsize(2)],sqrt(sqvx - vx.^2));
axis xy;
c = colorbar;
caxis('auto');
set(get(c,'Label'),'String','Horizontal velocity st. deviation [mm/s]');
set(c.Label,'FontSize',11);
xlabel('Horizontal position [mm]');
ylabel('Vertical position [mm]');
title(group,'interpreter','none');

pause(0.5);
print(gcf,'-dpng',sprintf(OUTFIGTEMPLATE,'stdvx',group));

imagesc([0 fovsize(1)],[0 fovsize(2)],sqrt(sqvy - vy.^2));
axis xy;
c = colorbar;
caxis('auto');
set(get(c,'Label'),'String','Vertical velocity st. deviation [mm/s]');
set(c.Label,'FontSize',11);
xlabel('Horizontal position [mm]');
ylabel('Vertical position [mm]');
title(group,'interpreter','none');

pause(0.5);
print(gcf,'-dpng',sprintf(OUTFIGTEMPLATE,'stdvy',group));

imagesc([0 fovsize(1)],[0 fovsize(2)],pts);
axis xy;
c = colorbar;
caxis('auto');
set(get(c,'Label'),'String','Points per bin');
set(c.Label,'FontSize',11);
xlabel('Horizontal position [mm]');
ylabel('Vertical position [mm]');
title(group,'interpreter','none');

pause(0.5);
print(gcf,'-dpng',sprintf(OUTFIGTEMPLATE,'pts',group));

% save the data
save(sprintf(OUTDATATEMPLATE,group),'eumap');

end
