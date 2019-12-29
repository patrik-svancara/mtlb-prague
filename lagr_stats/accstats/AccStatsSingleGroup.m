function [stats] = AccStatsSingleGroup(group,mov)
% Calculates acceleration statistics for a group of movies.
% Returns stats structure and saves the results.

% add dependencies
addpath('../');

% prepare output folder
RESTEMPLATE = '../../../results/lagr_res/%s/';
outfolder = sprintf(RESTEMPLATE,group);
if exist(outfolder,'dir') == 0
    
    mkdir(outfolder)
    
end

% outfile template
OUTFIGTEMPLATE = [outfolder 'accstat_%s_%s.png'];
OUTDATATEMPLATE = [outfolder 'accstat_data_%s.mat'];

% load data if not provided by external parameter
if nargin == 1
    MOVFRTEMPLATE = '../../../results/tracks/mov_%s.mat';
    load(sprintf(MOVFRTEMPLATE,group),'mov');
end

% preallocation of stats struct (for each movie + mean value)  
statsitem = struct('accstats',[],'accpdf',[]);
stats(1:length(mov)+1) = statsitem;

% init of total data vector
allaccdata = [ ];

for m = 1:length(mov)
    
    % message to the user
    fprintf('Processing run %d/%d\n',m,length(mov));
    
    [stats(m).accstats,stats(m).accpdf,accdata] = AccStatsSingleMov(mov(m));
    
    if ~isnan(accdata)
    
        allaccdata = cat(1,allaccdata,accdata);

        % figure of velocity PDF to the user
        semilogy(stats(m).accpdf.raw(:,1),stats(m).accpdf.raw(:,2),'-','LineWidth',1.5);
        hold on;
        semilogy(stats(m).accpdf.raw(:,3),stats(m).accpdf.raw(:,4),'-','LineWidth',1.5);
        hold off;
        xlabel('Particle acceleration [mm/s^2]');
        ylabel('PDF');
        legend('Horizontal','Vertical','Location','northeast');
        title(sprintf('Run %d/%d',m,length(mov)));

        pause(0.5);
        
    end
    
end

% global statistics
stats(end).accstats = Moments(allaccdata);
stats(end).accpdf.raw = GetPdf(allaccdata);

allaccdata = (allaccdata - stats(end).accstats.mean')./stats(end).accstats.std';
stats(end).accpdf.norm = GetPdf(allaccdata);

% final PDF - dimensional
semilogy(stats(end).accpdf.raw(:,1),stats(end).accpdf.raw(:,2),'-','LineWidth',1.5);
hold on;
semilogy(stats(end).accpdf.raw(:,3),stats(end).accpdf.raw(:,4),'-','LineWidth',1.5);
hold off;
xlabel('Particle acceleration [mm/s^2]');
ylabel('PDF');
legend('Horizontal','Vertical','Location','northeast');
title(group,'Interpreter','none');

pause(0.5);
print(gcf,'-dpng',sprintf(OUTFIGTEMPLATE,'pdfraw',group));

% final PDF - normalized
semilogy(stats(end).accpdf.norm(:,1),stats(end).accpdf.norm(:,2),'-','LineWidth',1.5);
hold on;
semilogy(stats(end).accpdf.norm(:,3),stats(end).accpdf.norm(:,4),'-','LineWidth',1.5);
hold off;
xlabel('Normalized particle acceleration');
ylabel('PDF');
legend('Horizontal','Vertical','Location','northeast');
title(group,'Interpreter','none');

pause(0.5);
print(gcf,'-dpng',sprintf(OUTFIGTEMPLATE,'pdfnorm',group));

% save the data
save(sprintf(OUTDATATEMPLATE,group),'stats');

end