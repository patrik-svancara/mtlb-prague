function [mcorr,mcorrpts] = NormVelCorrelationSingleGroup(group,tsepvec)
% Returns velocity autocorrelation function for normalized velocities for given time steps.

% prepare output folder
RESTEMPLATE = '../../results/velacf_res/%s/';
outfolder = sprintf(RESTEMPLATE,group);
if exist(outfolder,'dir') == 0
    
    mkdir(outfolder)
    
end

% outfile template
OUTFIGTEMPLATE = [outfolder 'velacf_%s.png'];
OUTFIG2TEMPLATE = [outfolder 'velacf_pts_%s.png'];
OUTDATATEMPLATE = [outfolder 'velacf_data_%s.mat'];

% load data
MOVFRTEMPLATE = '../../results/tracks/mov_%s.mat';
load(sprintf(MOVFRTEMPLATE,group),'mov');

% load stats
VELSTTEMPLATE = '../../results/lagr_res/%1$s/velstat_data_%1$s.mat';
load(sprintf(VELSTTEMPLATE,group),'stats');
st = stats(end);

% legend template
LEGTEMPLATE = ["Horizontal" "Vertical" "Absolute"];
lgnd = LEGTEMPLATE(1:size(mov(1).tr(1).vel,2));

% memory prealloc
mcorr = zeros(length(tsepvec),size(mov(1).tr(1).vel,2));
mcorrpts = zeros(length(tsepvec),1);

% message for the user
fprintf('Processing step %03d/%03d',0,length(tsepvec));

% through all the time steps
for k = 1:length(tsepvec)
    
    % message for the user
    fprintf('\b\b\b\b\b\b\b%03d/%03d',k,length(tsepvec));
    
    tsep = tsepvec(k);
    
    % memory preallocation
    corrs = zeros(length(mov),size(mov(1).tr(1).vel,2));
    wcorrs = zeros(length(mov),1);
    
    % through all the movies
    for m = 1:length(mov)
                
        [corrs(m,:),wcorrs(m)] = NormVelCorrelationSingleMov(mov(m),tsep,st);
        
    end
    
    % remove empty cases
    [corrs,ind] = RemoveNaN(corrs);
    wcorrs = wcorrs(ind);
    
    mcorrpts(k) = sum(wcorrs);
    mcorr(k,:) = sum(corrs.*wcorrs,1)./mcorrpts(k);
    
    % obtain camera fps
    fps = mov(1).caminfo.fps;
    
    % plot results for the user
    plot(tsepvec(1:k)/fps*1000,mcorr(1:k,:),'o-','LineWidth',1.5,'MarkerSize',4);
    legend(lgnd,'Location','northeast');
    xlabel('Time separation T [ms]');
    ylabel('Velocity autocorrelation [-]');
    title(sprintf('%s, step %d/%d',group,k,length(tsepvec)),'Interpreter','none');
    
    pause(0.2);
    
end

% finish progress line
fprintf('\n');

% plot final results
plot(tsepvec/fps*1000,mcorr,'o-','LineWidth',1.5,'MarkerSize',4);
legend(lgnd,'Location','northeast');
xlabel('Time separation T [ms]');
ylabel('Velocity autocorrelation [-]');
title(group,'Interpreter','none');

pause(0.2);
print(gcf,'-dpng',sprintf(OUTFIGTEMPLATE,group));

semilogy(tsepvec/fps*1000,mcorrpts,'ko-','LineWidth',1.5,'MarkerSize',4);
grid on;
xlabel('Time separation T [ms]');
ylabel('Number of correlated points [-]');
title(group,'Interpreter','none');

pause(0.2);
print(gcf,'-dpng',sprintf(OUTFIG2TEMPLATE,group));

% save the data
save(sprintf(OUTDATATEMPLATE,group),'mcorr','mcorrpts');

end