function [multivelstats] = VelStatsSingleGroup_MultiParams(group,paramslist)
% Calculates velocity statistics for multiple parametrizations
% Keeps only final stats, for each parametrization

% deps
addpath('../lagr_stats/');
addpath('../lagr_stats/velstats/');
addpath('../common/');

% folder with input files
INMOVTEMPLATE = '../../results/tracks/conv_%s/mov_%s_gauss%d.mat';

% intit output struct
multivelstats(1:size(paramslist,1)) = struct;

% prepare output folder
RESTEMPLATE = '../../results/conv_res/%s/';
outfolder = sprintf(RESTEMPLATE,group);
if exist(outfolder,'dir') == 0
    
    mkdir(outfolder)
    
end

OUTFIGTEMPLATE = [outfolder 'velpdf_%s_gauss%d.eps'];

% for all mov files specified by paramslist
for p = 1:size(paramslist,1)
    
    % message to the user
    fprintf('Processing option %d/%d\n',p,size(paramslist,1));
    
    % load data
    load(sprintf(INMOVTEMPLATE,group,group,paramslist(p,1)));
    
    % metadata to outuput struct
    multivelstats(p).gaussparams = paramslist(p,2:3);
    
    % init of total data vector
    allveldata = [ ];

    for m = 1:length(mov)

        [~,~,veldata] = VelStatsSingleMov(mov(m));

        if ~isnan(veldata)

            allveldata = cat(1,allveldata,veldata);
            
        end
        
    end
        
    % global statistics
    multivelstats(p).velstats = Moments(allveldata);
    multivelstats(p).velpdf.raw = GetPdf(allveldata);

    allveldata = (allveldata - multivelstats(p).velstats.mean')./multivelstats(p).velstats.std';
    multivelstats(p).velpdf.norm = GetPdf(allveldata);

    % plot PDF for the user
    semilogy(multivelstats(p).velpdf.raw(:,1),multivelstats(p).velpdf.raw(:,2),'-');
    hold on;
    semilogy(multivelstats(p).velpdf.raw(:,3),multivelstats(p).velpdf.raw(:,4),'-');
    hold off;
    xlabel('Particle velocity [mm/s]');
    ylabel('PDF');
    legend('Horizontal','Vertical','Location','northeast');
    title(sprintf('Group %s, Gauss %.1f-%d',group,multivelstats(p).gaussparams));

    pause(0.5);
    
    % save the figure
    print(gcf,'-depsc',sprintf(OUTFIGTEMPLATE,group,paramslist(p,1)));
    
end

% save output data
save([outfolder sprintf('multivelstats_%s',group)],'multivelstats');

end