function [theta] = DirChangeSingleGroup(group,hedges,tsepvec)
% Returns velocity fluctuation autocorrelation for given time steps.

% prepare output folder
RESTEMPLATE = '../../data/dir_change_res/%s/';
outfolder = sprintf(RESTEMPLATE,group);
if exist(outfolder,'dir') == 0
    
    mkdir(outfolder)
    
end

% outfile template
OUTFIGTEMPLATE = [outfolder 'theta_%s_%s.eps'];
OUTDATATEMPLATE = [outfolder 'theta_data_%s.mat'];

% load data
MOVFRTEMPLATE = '../../data/tracks/%s/mov_%s.mat';
load(sprintf(MOVFRTEMPLATE,group,group));

% obtain fps
fps = mov(1).caminfo.fps;

% histogram centers for plots
hcenters = (hedges(1:end-1) + hedges(2:end))/2;

% init of output structure
thitem = struct('pdf',[],'mean',[],'npoints',[],'tsep',[]);
theta(1:length(tsepvec)) = thitem;


% through all the time steps
for k = 1:length(tsepvec)
    
    tsep = tsepvec(k);
    
    % time separation in ms
    theta(k).tsep = tsep/fps*1000;
    
    % memory prealloc
    mthetas = zeros(length(mov),1);
    wthetas = mthetas;
    hcts = zeros(1,length(hedges)-1);
    
    % through all the movies
    for m = 1:length(mov)
                
        [mthetas(m),wthetas(m),hctspart] = DirChangeSingleMov(mov(m),hedges,tsep);
        
        % normalization
        hctspart = hctspart./(sum(hctspart)*(hedges(2) - hedges(1)));
        
        % plot for the user
        plot(hcenters,hctspart,'.-');
        xlabel('Normalized directional angle');
        ylabel('PDF');
        title(sprintf('Step %d, run %d/%d',tsep,m,length(mov)));
        
        pause(0.2);
        
        % add data to global statistic
        hcts = hcts + hctspart;
        
    end
    
    % make group-wide means
    theta(k).mean = sum(mthetas.*wthetas)/sum(wthetas);
    theta(k).npoints = sum(wthetas);
    
    
    % group-wide histogram normalization
    hcts = hcts./(sum(hcts)*(hedges(2) - hedges(1)));

    % save histogram
    theta(k).pdf = [hcenters' hcts'];

    % plot for the user
    for j = 1:k
        semilogy(theta(j).pdf(:,1),theta(j).pdf(:,2),'.-');
        hold on;
    end
    hold off;
    xlabel('Normalized directional angle');
    ylabel('PDF');
    legend(cellstr(string(tsepvec(1:k)/fps*1000)+" ms"));
    title(group);
    
    pause(1);
    
end

% save the final PDF plot
print(gcf,'-depsc',sprintf(OUTFIGTEMPLATE,'pdf',group));

loglog([theta(:).tsep],[theta(:).mean],'o-');
xlabel('Time separation [ms]');
ylabel('Mean directional angle [rad]');
title(group);

pause(0.2);

print(gcf,'-depsc',sprintf(OUTFIGTEMPLATE,'mean',group));


% save the data
save(sprintf(OUTDATATEMPLATE,group),'theta');

end