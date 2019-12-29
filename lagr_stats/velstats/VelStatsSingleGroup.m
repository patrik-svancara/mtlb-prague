function [stats] = VelStatsSingleGroup(group,mov)
% Calculates velocity statistics for a group of movies.
% Returns stats structure and saves the results.

% add dependencies
addpath('../');
addpath('../../common/');

% prepare output folder
RESTEMPLATE = '../../../results/lagr_res/%s/';
outfolder = sprintf(RESTEMPLATE,group);
if exist(outfolder,'dir') == 0
    
    mkdir(outfolder)
    
end

% outfile template
OUTFIGTEMPLATE = [outfolder 'velstat_%s_%s.png'];
OUTDATATEMPLATE = [outfolder 'velstat_data_%s.mat'];

% load data
if nargin == 1
    MOVFRTEMPLATE = '../../../results/tracks/mov_%s.mat';
    load(sprintf(MOVFRTEMPLATE,group),'mov');
end

% preallocation of stats struct (for each movie + mean value)  
statsitem = struct('velstats',[],'velpdf',[]);
stats(1:length(mov)+1) = statsitem;

% init of total data vector
allveldata = [ ];

for m = 1:length(mov)
    
    % message to the user
    fprintf('Processing run %d/%d\n',m,length(mov));
    
    [stats(m).velstats,stats(m).velpdf,veldata] = VelStatsSingleMov(mov(m));
    
    if ~isnan(veldata)
    
        allveldata = cat(1,allveldata,veldata);

        % figure of velocity PDF to the user
        semilogy(stats(m).velpdf.raw(:,1),stats(m).velpdf.raw(:,2),'-','LineWidth',1.5);
        hold on;
        semilogy(stats(m).velpdf.raw(:,3),stats(m).velpdf.raw(:,4),'-','LineWidth',1.5);
        hold off;
        xlabel('Particle velocity [mm/s]');
        ylabel('PDF');
        legend('Horizontal','Vertical','Location','northeast');
        title(sprintf('Run %d/%d',m,length(mov)),'Interpreter','none');

        pause(0.5);
        
    end
    
end

% global statistics
stats(end).velstats = Moments(allveldata);
stats(end).velpdf.raw = GetPdf(allveldata);

allveldata = (allveldata - stats(end).velstats.mean')./stats(end).velstats.std';
stats(end).velpdf.norm = GetPdf(allveldata);

% final PDF - dimensional
semilogy(stats(end).velpdf.raw(:,1),stats(end).velpdf.raw(:,2),'-','LineWidth',1.5);
hold on;
semilogy(stats(end).velpdf.raw(:,3),stats(end).velpdf.raw(:,4),'-','LineWidth',1.5);
hold off;
xlabel('Particle velocity [mm/s]');
ylabel('PDF');
legend('Horizontal','Vertical','Location','northeast');
title(group,'Interpreter','none');

pause(0.5);
print(gcf,'-dpng',sprintf(OUTFIGTEMPLATE,'pdfraw',group));

% final PDF - normalized
semilogy(stats(end).velpdf.norm(:,1),stats(end).velpdf.norm(:,2),'-','LineWidth',1.5);
hold on;
semilogy(stats(end).velpdf.norm(:,3),stats(end).velpdf.norm(:,4),'-','LineWidth',1.5);
hold off;
xlabel('Normalized particle velocity');
ylabel('PDF');
legend('Horizontal','Vertical','Location','northeast');
title(group,'Interpreter','none');

pause(0.5);
print(gcf,'-dpng',sprintf(OUTFIGTEMPLATE,'pdfnorm',group));

% save the data
save(sprintf(OUTDATATEMPLATE,group),'stats');

end