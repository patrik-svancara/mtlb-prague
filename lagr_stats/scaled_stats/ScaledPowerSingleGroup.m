function [scpwr] = ScaledPowerSingleGroup(group,stepvec)
% Provides scale-dependent power statistics for a series of steps
% defined by stepvec vector.

% add deps
addpath('../');
addpath('../../common/');

% prepare output folder
RESTEMPLATE = '../../../results/scaled_res/%s/';
outfolder = sprintf(RESTEMPLATE,group);
if exist(outfolder,'dir') == 0
    
    mkdir(outfolder)
    
end

% outfile template
OUTFIGTEMPLATE = [outfolder 'scpwr_%s_%s.png'];
OUTDATATEMPLATE = [outfolder 'scpwr_data_%s.mat'];

% load data
MOVFRTEMPLATE = '../../../results/tracks/mov_%s.mat';
load(sprintf(MOVFRTEMPLATE,group));

% preallocation of stats struct (for each time step)  
pwritem = struct('pwrstats',[],'pwrpdf',[]);
scpwr(1:length(stepvec)) = pwritem;

% colors for the plot
cols = parula(length(stepvec));

for k = 1:length(stepvec)
    
    % current step
    step = stepvec(k);
    scpwr(k).step = step;
    
    % message to the user
    fprintf('Processing step %d/%d\n',k,length(stepvec));
    
    % init global data vectors
    allpwr = [ ];
    
    % for all the movies
    for m = 1:length(mov)
        
        movpwr = ScaledPowerSingleMov(mov(m),step);
        
        if ~isnan(movpwr)
            
            allpwr = cat(1,allpwr,movpwr);
            
        end
        
    end
    
    % global (group-wide) stats
    scpwr(k).pwrstats = Moments(allpwr);
    scpwr(k).pwrpdf.raw = GetPdf(allpwr);
    
    allpwr = (allpwr - scpwr(k).pwrstats.mean)/scpwr(k).pwrstats.std;
    scpwr(k).pwrpdf.norm = GetPdf(allpwr);
    
    % plot for the user      
    semilogy(scpwr(k).pwrpdf.norm(:,1),scpwr(k).pwrpdf.norm(:,2),...
        '-','Color',cols(k,:),'LineWidth',1.3);
    
    hold on;
    
    xlabel('Normalized power');
    ylabel('PDF');
    title(sprintf('Step %d/%d',k,length(stepvec)));
    
    pause(0.2);

end

% make & save final figures

% power distro
title(sprintf('Group %s',group),'Interpreter','none');
pause(2);

print(gcf,'-dpng',sprintf(OUTFIGTEMPLATE,'pwrpdf',group));

hold off;

% power skewness
allskew = zeros(length(stepvec),1);

for k = 1:length(stepvec)
    allskew(k) = scpwr(k).pwrstats.skew;
end

plot(stepvec,allskew,'+-','LineWidth',1.3);
xlabel('Scaling step [frames]');
ylabel('Power skewness');
title(sprintf('Group %s',group),'Interpreter','none');

pause(2);
print(gcf,'-dpng',sprintf(OUTFIGTEMPLATE,'pwrskew',group));

% save the data
save(sprintf(OUTDATATEMPLATE,group),'scpwr');

end