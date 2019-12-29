function [mov] = TrSplitSingleGroup(group,trhold)
% (1) Calculates relevant line diffs for the given group tracks.
% (2) Calculates line diff distribution moments.
% (3) Splits trajectories onto "straight" and "curved" segments and saves
% them.

% prepare output folder
RESTEMPLATE = '../../data/lin_dev_split_res/%s/';
outfolder = sprintf(RESTEMPLATE,group);
if exist(outfolder,'dir') == 0
    
    mkdir(outfolder)
    
end

% outfile template
OUTFIGTEMPLATE = [outfolder 'linedev_pdf_%s.eps'];
OUTDATATEMPLATE = [outfolder 'splmov_%s.mat'];

% load data
MOVFRTEMPLATE = '../../data/tracks/%s/mov_%s.mat';
load(sprintf(MOVFRTEMPLATE,group,group));

%% Calculate line diffs for original movies

% message for the user
fprintf('Calculating diffs...\n');

% frame span for line diff evaluation
TSEP = 2;

for m = 1:length(mov)
    
    for t = 1:length(mov(m).tr)
        
         [mov(m).tr(t).diff,mov(m).tr(t).truedifflength] = LineDevSingleTrack(mov(m).tr(t),TSEP);
         
    end
    
end

%% Make lin diff stats

% message for the user
fprintf('Making diff stats...\n');

% main calcul
lds = MakeLineDevStats(mov);

% plot distro and save the figure
semilogy(lds.pdf(:,3),lds.pdf(:,4),'+-','LineWidth',1.3);
xlabel('Normalized vertical diff');
ylabel('PDF');
title(sprintf('Group %s',group));
    
pause(0.5);

print(gcf,'-depsc',sprintf(OUTFIGTEMPLATE,group));
  
%% Trajectory fragmentation

% message for the user
fprintf('Fragmenting trajectories...\n');

% treshold in absolute values (multiply by vertical line diff standard deviation)
abstrhold = trhold.*lds.mom(4,2);

% for all movies
for m = 1:length(mov)
    
    % message for the user
    fprintf('Processing run %d/%d\n',m,length(mov));
    
    % for all trajectories
    for t = 1:length(mov(m).tr)

        mov(m).tr(t).spltr = TrSplitSingleTr(mov(m).tr(t),abstrhold);
        
    end
    
end

% save data
% save(sprintf(OUTDATATEMPLATE,group),'mov');