function [linedev] = LineDevSingleGroup(group,tsepvec,limits)
% (1) Calculates linear dieviations for al tracks in the group.
% (2) Makes lindev statistics.
% (3) Makes particle velocity statistics conditioned by various segments of
% lindev histograms, specified by limits.
% (4) Saves velocity distribution histograms and all resulting data.
% (5) Repeats for all time steps in tsepvec vector

% prepare output folder
RESTEMPLATE = '../../data/lin_dev_res/%s/';
outfolder = sprintf(RESTEMPLATE,group);
if exist(outfolder,'dir') == 0
    
    mkdir(outfolder)
    
end

% outfile template
OUTFIGTEMPLATE = [outfolder 'velpdf_lim%d_%s.eps'];
OUTDATATEMPLATE = [outfolder 'linedev_data_%s.mat'];

% load data
MOVFRTEMPLATE = '../../data/tracks/%s/mov_%s.mat';
load(sprintf(MOVFRTEMPLATE,group,group));

% prealloc output struct
linedevitem = struct('tsep',[],'lds',[],'cvs',[]);
linedev(1:length(tsepvec)) = linedevitem;

% through all the time steps
for ts = 1:length(tsepvec)
    
    % message to the user
    fprintf('*** Time step %d/%d ***\n',ts,length(tsepvec));
    
    tsep = tsepvec(ts);
    
    linedev(ts).tsep = tsep;
    
    %%% Calculate tr.diff %%%
    % message for the user
    fprintf('Calculating diffs...\n');
    
    for m = 1:length(mov)
        
        for t = 1:length(mov(m).tr)
            
            [mov(m).tr(t).diff,mov(m).tr(t).truedifflength] = LineDevSingleTrack(mov(m).tr(t),tsep);
            
        end
    end
    
    %%% Make line deviation statistics %%%
    % message for the user
    fprintf('Making diff stats...\n');
    
    linedev(ts).lds = MakeLineDevStats(mov);
    
    % plot for the user
    semilogy(linedev(ts).lds.pdf(:,3),linedev(ts).lds.pdf(:,4),'-');
    xlabel('Normalized vertical diff');
    ylabel('PDF');
    title(sprintf('Time step %d, %s',tsep,group));
    
    pause(1);
    
    %%% Make conditioned velocity statistics %%%
    % message for the user
    fprintf('Calculating conditioned velocity stats...\n');

    linedev(ts).cvs = MakeCondVelStats(mov,linedev(ts).lds,limits);
    
    % preview plots for the user
    for n = 1:length(linedev(ts).cvs)
        
        semilogy(linedev(ts).cvs(n).pdf(:,1),linedev(ts).cvs(n).pdf(:,2),'.-');
        hold on;
        semilogy(linedev(ts).cvs(n).pdf(:,3),linedev(ts).cvs(n).pdf(:,4),'.-');
        hold off;
        xlabel('Particle velocity [mm/s]');
        ylabel('PDF');
        title(sprintf('Time step %d, %s; condition [%g;%g]',tsep,group,linedev(ts).cvs(n).limit));
        
        pause(1);
        
    end

end

%%% final plots, one for each limit item %%%
% define colors
color = jet(length(tsepvec));

for n = 1:size(limits,1)
    
    figure;
    
    for ts = 1:length(tsepvec)
        
        % horizontal PDF (normalized by std)
        xvelstd = linedev(ts).cvs(n).mom(4,1);
        xpdfbins = linedev(ts).cvs(n).pdf(:,1);
        xpdfcts = linedev(ts).cvs(n).pdf(:,2);
        
        % vertical PDF (normalized)
        yvelstd = linedev(ts).cvs(n).mom(4,2);
        ypdfbins = linedev(ts).cvs(n).pdf(:,3);
        ypdfcts = linedev(ts).cvs(n).pdf(:,4);
        
        % plot these PDFs
        linetolegend(ts) =  semilogy(xpdfbins,xpdfcts,'-','Color',color(ts,:));
        hold on;
        semilogy(ypdfbins,ypdfcts,'-.','Color',color(ts,:));
        hold on;
        
    end
    
    % graph design
    set(gca,'YScale','log');
    
    xlabel('Particle velocity [mm/s]');
    ylabel('PDF');
    legend(linetolegend,"tsep = "+num2str(tsepvec'),'Location','northwest');
    title(sprintf('%s, condition [%g;%g]',group,linedev(1).cvs(n).limit));
    
    pause(1);
    
    % save the figure
    print(gcf,'-depsc',sprintf(OUTFIGTEMPLATE,n,group));

end

% save the data
save(sprintf(OUTDATATEMPLATE,group),'linedev');

end
    

    