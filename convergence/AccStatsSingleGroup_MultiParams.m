function [multiaccstats] = AccStatsSingleGroup_MultiParams(group,paramslist)
% Calculates acdeleration statistics for multiple parametrizations
% Keeps only final stats, for each parameter option

% deps
addpath('../lagr_stats/');
addpath('../lagr_stats/accstats/');
addpath('../common/');

% folder with input files
INMOVTEMPLATE = '../../results/tracks/conv_%s/mov_%s_gauss%d.mat';

% intit output struct
multiaccstats(1:size(paramslist,1)) = struct;

% prepare output folder
RESTEMPLATE = '../../results/conv_res/%s/';
outfolder = sprintf(RESTEMPLATE,group);
if exist(outfolder,'dir') == 0
    
    mkdir(outfolder)
    
end

OUTFIGTEMPLATE = [outfolder 'accpdf_%s_gauss%d.eps'];

% for all mov files specified by paramslist
for p = 1:size(paramslist,1)
    
    % message to the user
    fprintf('Processing option %d/%d\n',p,size(paramslist,1));
    
    % load data
    load(sprintf(INMOVTEMPLATE,group,group,paramslist(p,1)));
    
    % metadata to outuput struct
    multiaccstats(p).gaussparams = paramslist(p,2:3);
    
    % init of total data vector
    allaccdata = [ ];

    for m = 1:length(mov)

        [~,~,accdata] = AccStatsSingleMov(mov(m));

        if ~isnan(accdata)

            allaccdata = cat(1,allaccdata,accdata);
            
        end
        
    end
        
    % global statistics
    multiaccstats(p).accstats = Moments(allaccdata);
    
    % debugging
    disp(size(allaccdata));
    
    multiaccstats(p).accpdf.raw = GetPdf(allaccdata);

    allaccdata = (allaccdata - multiaccstats(p).accstats.mean')./multiaccstats(p).accstats.std';
    multiaccstats(p).accpdf.norm = GetPdf(allaccdata);

    % plot PDF for the user
    semilogy(multiaccstats(p).accpdf.raw(:,1),multiaccstats(p).accpdf.raw(:,2),'-');
    hold on;
    semilogy(multiaccstats(p).accpdf.raw(:,3),multiaccstats(p).accpdf.raw(:,4),'-');
    hold off;
    xlabel('Particle acceleration [mm/s^2]');
    ylabel('PDF');
    legend('Horizontal','Vertical','Location','northeast');
    title(sprintf('Group %s, Gauss %.1f-%d',group,multiaccstats(p).gaussparams));

    pause(0.5);
    
    % save the figure
    print(gcf,'-depsc',sprintf(OUTFIGTEMPLATE,group,paramslist(p,1)));
    
end

% save output data
save([outfolder sprintf('multiaccstats_%s',group)],'multiaccstats');

end