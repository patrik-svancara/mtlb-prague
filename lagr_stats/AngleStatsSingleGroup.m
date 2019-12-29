function [astats] = AngleStatsSingleGroup(group)
% Calculates tatistics of angles between velocity components for a group of movies.
% Returns stats structure and saves the results.

% add dependencies
addpath('./');
addpath('../common/');

% prepare output folder
RESTEMPLATE = '../../results/lagr_res/%s/';
outfolder = sprintf(RESTEMPLATE,group);
if exist(outfolder,'dir') == 0
    
    mkdir(outfolder)
    
end

% outfile template
OUTFIGTEMPLATE = [outfolder 'anglestat_%s_%s.png'];
OUTDATATEMPLATE = [outfolder 'anglestat_data_%s.mat'];

% load data
MOVFRTEMPLATE = '../../results/tracks/mov_%s.mat';
load(sprintf(MOVFRTEMPLATE,group),'mov');

% preallocation of stats struct (for each movie + mean value)  
statsitem = struct('astats',[],'apdf',[]);
astats(1:length(mov)+1) = statsitem;

% init of total data vector
alldata = [ ];

for m = 1:length(mov)
    
    % message to the user
    fprintf('Processing run %d/%d\n',m,length(mov));
    
    [astats(m).astats,astats(m).apdf,adata] = AngleStatsSingleMov(mov(m));
    
    if ~isnan(adata)
    
        alldata = cat(1,alldata,adata);

        % figure of velocity PDF to the user
        plot(astats(m).apdf.raw(:,1),astats(m).apdf.raw(:,2),'-','LineWidth',1.3);
        
        xlim([-1 1]);
        ylim auto;
        
        xlabel('Velocity direction angle [\pi]');
        ylabel('PDF [-]');
        
        title(sprintf('Run %d/%d',m,length(mov)),'Interpreter','none');

        pause(0.5);
        
    end
    
end

% global statistics
astats(end).astats = Moments(alldata);
astats(end).apdf.raw = GetPdf(alldata);

% plot & save final PDF
plot(astats(end).apdf.raw(:,1),astats(end).apdf.raw(:,2),'-','LineWidth',1.3);

xlim([-1 1]);
ylim auto;

xlabel('Velocity direction angle [\pi]');
ylabel('PDF [-]');

title(group,'Interpreter','none');

pause(0.5);
print(gcf,'-dpng',sprintf(OUTFIGTEMPLATE,'pdfraw',group));

% save the data
save(sprintf(OUTDATATEMPLATE,group),'astats');

end