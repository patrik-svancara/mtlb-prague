function [pwinc] = PowerIncSingleGroup(group,tsepvec)
% Returns (processed) power increment structure for each movie and for the
% entire group. A vector of time steps is used.

% deps
addpath('../../common/');

% prepare output folder
RESTEMPLATE = '../../../results/lagr_res/%s/';
outfolder = sprintf(RESTEMPLATE,group);
if exist(outfolder,'dir') == 0
    
    mkdir(outfolder)
    
end

% outfile template
OUTFIGTEMPLATE = [outfolder 'pwinc_%s_%s.png'];
OUTDATATEMPLATE = [outfolder 'pwinc_data_%s.mat'];

% load data
MOVFRTEMPLATE = '../../../results/tracks/mov_%s.mat';
load(sprintf(MOVFRTEMPLATE,group));

% parula for plots
cols = parula(length(tsepvec));

% preallocation of the resulting structure (for each time step)
statsitem = struct('pwincstats',[],'pwincpdf',[],'tsep',[]);
pwinc(1:length(tsepvec)) = statsitem;

% through all the time steps
for k = 1:length(tsepvec)
    
    % message for the user
    fprintf('Processing step %d/%d\n',k,length(tsepvec));
    
    tsep = tsepvec(k);
    
    % memory "preallocation" (will be updated only a couple of times)
    allpwinc = [ ];
    
    % through all the movies
    for m = 1:length(mov)
                
        [movpwinc] = PowerIncSingleMov(mov(m),tsep);
        
        % merge local data with global data
        allpwinc = cat(1,allpwinc,movpwinc);
        
    end
    
    % Remove empty cases
    allpwinc = RemoveNaN(allpwinc);
    
    % make stats and PDF
    pwinc(k).pwincstats = Moments(allpwinc);
    pwinc(k).pwincpdf = GetPdf(allpwinc);
    
    pwinc(k).tsep = tsep;
    
    % plot of power PDF, normalized by the standard deviation, for the user
    stdev = pwinc(k).pwincstats.std;
    semilogy(pwinc(k).pwincpdf(:,1)/stdev,pwinc(k).pwincpdf(:,2)*stdev,'-','LineWidth',1.3,'Color',cols(k,:));
    
    hold on;
    
    xlabel('Normalized power increment');
    ylabel('PDF');
    title(sprintf('%s, step %d/%d',group,k,length(tsepvec)),'Interpreter','none');
    
    pause(0.2);
    
end

% final plot
title(sprintf('Group %s',group));
%legend("tau = "+string(tsepvec),'Location','northeast');
hold off;

% save the figure
print(gcf,'-dpng',sprintf(OUTFIGTEMPLATE,'pdf',group));

% obtain data for the final skewness plot
skewind = 1;

for k = 1:length(tsepvec)
    skewtoplot(skewind) = pwinc(k).pwincstats.skew;
    skewind = skewind + 1;
end

% plot final skewness plot
plot(tsepvec,skewtoplot,'+-','LineWidth',1.3);
xlabel('Time separation [frames]');
ylabel('Skewness of power increments');
title(sprintf('Group %s',group),'Interpreter','none');

pause(0.2);

% save the figure
print(gcf,'-dpng',sprintf(OUTFIGTEMPLATE,'skew',group));

% save output data
save(sprintf(OUTDATATEMPLATE,group),'pwinc');


end