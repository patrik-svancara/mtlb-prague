function [mcorr] = VelCorrelationSingleGroup(group,tsepvec)
% Returns velocity fluctuation autocorrelation for given time steps.

% prepare output folder
RESTEMPLATE = '../../results/lagr_res/%s/';
outfolder = sprintf(RESTEMPLATE,group);
if exist(outfolder,'dir') == 0
    
    mkdir(outfolder)
    
end

% outfile template
OUTFIGTEMPLATE = [outfolder 'velacf_%s.eps'];
OUTDATATEMPLATE = [outfolder 'velacf_data_%s.mat'];

% load data
MOVFRTEMPLATE = '../../results/tracks/mov_%s.mat';
load(sprintf(MOVFRTEMPLATE,group));

% load mean velocity map
MOVGRTEMPLATE = '../../results/euler_res/%s/eumap_data_%s.mat';
load(sprintf(MOVGRTEMPLATE,group,group));


% memory prealloc
mcorr = zeros(length(tsepvec),2);

% through all the time steps
for k = 1:length(tsepvec)
    
    % message for the user
    fprintf('Processing step %d/%d\n',k,length(tsepvec));
    
    tsep = tsepvec(k);
    
    % memory preallocation
    corrs = zeros(length(mov),2);
    wcorrs = zeros(length(mov),1);
    
    % through all the movies
    for m = 1:length(mov)
                
        [corrs(m,:),wcorrs(m)] = VelCorrelationSingleMov(mov(m),tsep,eumap(m).gr);
        
    end
    
    mcorr(k,:) = sum(corrs.*wcorrs)/sum(wcorrs);
    
    % obtain camera fps
    fps = mov(1).caminfo.fps;
    
    % plot results for the user
    plot(tsepvec(1:k)/fps*1000,mcorr(1:k,:),'o-');
    legend('Horizontal','Vertical','Location','northeast');
    xlabel('Time separation T [ms]');
    ylabel('Velocity fluctuation autocorrelation [(mm/s)^2]');
    title(sprintf('%s, step %d/%d',group,k,length(tsepvec)));
    
    pause(0.2);
    
end

% plot final results and save the data
plot(tsepvec/fps*1000,mcorr,'o-');
legend('Horizontal','Vertical','Location','northeast');
xlabel('Time separation T [ms]');
ylabel('Velocity fluctuation autocorrelation [(mm/s)^2]');
title(group);

pause(0.2);
print(gcf,'-depsc',sprintf(OUTFIGTEMPLATE,group));

% save the data
save(sprintf(OUTDATATEMPLATE,group));


end
