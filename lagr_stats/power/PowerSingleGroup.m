function [pwr] = PowerSingleGroup(group)
% Returns (processed) input powers for each movie and for the
% entire group.

% deps
addpath('../');

% prepare output folder
RESTEMPLATE = '../../../results/lagr_res/%s/';
outfolder = sprintf(RESTEMPLATE,group);
if exist(outfolder,'dir') == 0
    
    mkdir(outfolder)
    
end

% outfile template
OUTFIGTEMPLATE = [outfolder 'pwr_pdf_%s.png'];
OUTDATATEMPLATE = [outfolder 'pwr_data_%s.mat'];

% load data
MOVFRTEMPLATE = '../../../results/tracks/mov_%s.mat';
load(sprintf(MOVFRTEMPLATE,group));

% preallocation of the resulting structure (for each time step)
statsitem = struct('pwrstats',[],'pwrpdf',[]);
pwr(1:length(mov)+1) = statsitem;

% memory "preallocation" (will be updated only a couple of times)
allpwr = [ ];
    
% through all the movies
for m = 1:length(mov)
    
    % message for the user
    fprintf('Processing run %d/%d\n',m,length(mov));
    
    % collect movie-wide data
    [movpwr] = PowerSingleMov(mov(m));
        
    % merge with global data
    allpwr = cat(1,allpwr,movpwr);
    
    % movie-wide stats
    pwr(m).pwrstats = Moments(movpwr);
    pwr(m).pwrpdf.raw = GetPdf(movpwr);
    
    % normalized PDF
    movpwr = (movpwr - pwr(m).pwrstats.mean)/pwr(m).pwrstats.std;
    pwr(m).pwrpdf.norm = GetPdf(movpwr);
    
    % plot raw PDF for the user
    semilogy(pwr(m).pwrpdf.raw(:,1),pwr(m).pwrpdf.raw(:,2),'LineWidth',1.3);
    xlabel('Input power [10^{-6} W]');
    ylabel('PDF');
    title(sprintf('%s, run %d/%d',group,m,length(mov)),'Interpreter','none');
    
    pause(0.2);
         
end

% global stats
pwr(end).pwrstats = Moments(allpwr);
pwr(end).pwrpdf.raw = GetPdf(allpwr);

% normalized PDF
allpwr = (allpwr - pwr(end).pwrstats.mean)/pwr(end).pwrstats.std;
pwr(end).pwrpdf.norm = GetPdf(allpwr);

% final plot for the user
semilogy(pwr(end).pwrpdf.raw(:,1),pwr(end).pwrpdf.raw(:,2),'LineWidth',1.3);
hold on;
semilogy(-pwr(end).pwrpdf.raw(:,1),pwr(end).pwrpdf.raw(:,2),'-.','LineWidth',1.3);
hold off
xlabel('Input power [10^{-6} W]');
ylabel('PDF');
title(sprintf('Group %s',group),'Interpreter','none');
    
pause(0.2);

% save the figure
print(gcf,'-dpng',sprintf(OUTFIGTEMPLATE,group));

% save output data
save(sprintf(OUTDATATEMPLATE,group),'pwr');

end