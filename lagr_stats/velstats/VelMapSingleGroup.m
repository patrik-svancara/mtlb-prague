function [velmap] = VelMapSingleGroup(group)
% Calculates 2-D velocity distribution for a group of movies.
% Returns velmaps structure and saves the results.

% add dependencies
addpath('../');

% prepare output folder
RESTEMPLATE = '../../../results/lagr_res/%s/';
outfolder = sprintf(RESTEMPLATE,group);
if exist(outfolder,'dir') == 0
    
    mkdir(outfolder)
    
end

% outfile template
OUTFIGTEMPLATE = [outfolder 'velmap_%s_%s.eps'];
OUTDATATEMPLATE = [outfolder 'velmap_data_%s.mat'];

% load data
MOVFRTEMPLATE = '../../../results/tracks/mov_%s.mat';
load(sprintf(MOVFRTEMPLATE,group));

% preallocation of stats struct (for each movie + mean value)  
velmap(1:length(mov)+1) = struct('velstats',[],'map',[]);

% init of total data vector
allveldata = [ ];

for m = 1:length(mov)
    
    % message to the user
    fprintf('Processing run %d/%d\n',m,length(mov));
    
    [velmap(m).velstats,velmap(m).map,veldata] = VelMapSingleMov(mov(m));
    
    allveldata = cat(1,allveldata,veldata);
    
    % figure of velocity PDF to the user
    imagesc(velmap(m).map.raw.xedg([1 end]),velmap(m).map.raw.yedg([1 end]),log10(velmap(m).map.raw.pdf));
    axis xy;
    c = colorbar;
    caxis('auto');
    set(get(c,'Label'),'String','Log(PDF)');
    set(c.Label,'FontSize',11);
    xlabel('Horizontal velocity [mm/s]');
    ylabel('Vertical velocity [mm/s]');
    title(sprintf('Run %d/%d',m,length(mov)));
    
    pause(0.5);
    
end

% global statistics
velmap(end).velstats = Moments(allveldata);
velmap(end).map.raw = GetPdfMap(allveldata);

allveldata = (allveldata - velmap(end).velstats.mean')./velmap(end).velstats.std';
velmap(end).map.norm = GetPdfMap(allveldata);

% final PDF - dimensional
imagesc(velmap(end).map.raw.xedg([1 end]),velmap(end).map.raw.yedg([1 end]),log10(velmap(end).map.raw.pdf));
axis xy;
c = colorbar;
caxis('auto');
set(get(c,'Label'),'String','Log(PDF)');
set(c.Label,'FontSize',11);
xlabel('Horizontal velocity [mm/s]');
ylabel('Vertical velocity [mm/s]');
title(group);

pause(0.5);
print(gcf,'-depsc',sprintf(OUTFIGTEMPLATE,'pdfraw',group));

% final PDF - normalized
imagesc(velmap(end).map.norm.xedg([1 end]),velmap(end).map.norm.yedg([1 end]),log10(velmap(end).map.norm.pdf));
axis xy;
c = colorbar;
caxis('auto');
set(get(c,'Label'),'String','Log(PDF)');
set(c.Label,'FontSize',11);
xlabel('Normalized horizontal velocity');
ylabel('Normalized vertical velocity');
title(group);

pause(0.5);
print(gcf,'-depsc',sprintf(OUTFIGTEMPLATE,'pdfnorm',group));

% save the data
save(sprintf(OUTDATATEMPLATE,group),'velmap');

end