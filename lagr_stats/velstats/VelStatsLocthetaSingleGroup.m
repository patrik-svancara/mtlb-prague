function [stats] = VelStatsLocthetaSingleGroup(group,frrange,trhvec)
% Calculates velocity statistics for a group of movies, based on the local
% theta value compared to the trhold (n×2 vector), in the frame range
% specified by frrange (2-item vector).
% Returns stats (n×(length(mov)+1) structure and saves the results.
% No figures are saved automatically.

% NUMBER OF BINS
NBINS = 600;

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
OUTDATATEMPLATE = [outfolder 'velstatflag_trhvec_data_%s.mat'];

% load data
MOVFRTEMPLATE = '../../../results/tracks/mov_%s.mat';
load(sprintf(MOVFRTEMPLATE,group));

% preallocation of stats struct (for each threshold and movie + mean across
% movies)
statsitem = struct('velstats',[],'velpdf',[]);
stats(size(trhvec,1):length(mov)+1) = statsitem;

% for all threshold values
for h = 1:size(trhvec,1)
    
    % message to the user
    fprintf('*** Threshold %d/%d ***\n',h,size(trhvec,1));
    
    % save threshold vaues
    for m = 1:size(stats,2)
        stats(h,m).trh = trhvec(h,:);
        stats(h,m).frrange = frrange;
    end
    
    % flag the data
    for m = 1:length(mov)

        for t = 1:length(mov(m).tr)
            
            % local theta flagging
            mov(m).tr(t).thflag = and(trhvec(h,1) <= abs(mov(m).tr(t).ltheta),...
                abs(mov(m).tr(t).ltheta) <= trhvec(h,2));
            
            % flagging according to frrange
            mov(m).tr(t).frflag = and(frrange(1) <= mov(m).tr(t).fr,...
                mov(m).tr(t).fr <= frrange(2));
            
            % both conditions must be fulfilled
            mov(m).tr(t).flag = and(mov(m).tr(t).thflag',mov(m).tr(t).frflag);

        end
    end

    % init of total data vector
    allveldata = [ ];
    
    % through all movies
    for m = 1:length(mov)
        
        % message to the user
        fprintf('Processing run %d/%d\n',m,length(mov));
        
        [stats(h,m).velstats,stats(h,m).velpdf,veldata] = VelStatsFlagSingleMov(mov(m),true,NBINS);
        
        if ~isnan(veldata)
    
            allveldata = cat(1,allveldata,veldata);

            % figure of velocity PDF to the user
            semilogy(stats(h,m).velpdf.raw(:,1),stats(h,m).velpdf.raw(:,2),'-','LineWidth',1.5);
            hold on;
            semilogy(stats(h,m).velpdf.raw(:,3),stats(h,m).velpdf.raw(:,4),'-','LineWidth',1.5);
            hold on;

            xlabel('Particle velocity [mm/s]');
            ylabel('PDF');
            legend('Horizontal','Vertical','Location','northeast');
            
            title(sprintf('Run %d/%d, T = [%.1f,%.1f]',m,length(mov),stats(h,m).trh));
            hold off;

            pause(0.5);
        
        end
    
    end
    
    % fix the issue of empty data
    if isempty(allveldata)
        
        stats(h,end).velstats.pts = [0 0 0];
        stats(h,end).velstats.mean = NaN*ones(1,3);
        stats(h,end).velstats.rms = NaN*ones(1,3);
        stats(h,end).velstats.std = NaN*ones(1,3);
        stats(h,end).velstats.skew = NaN*ones(1,3);
        stats(h,end).velstats.flat = NaN*ones(1,3);

        stats(h,end).velpdf.raw = NaN*ones(1,6);
        stats(h,end).velpdf.norm = NaN*ones(1,6);
        
    else

        % global statistics
        stats(h,end).velpdf.raw = GetPdf(allveldata,NBINS);
        
        stats(h,end).velstats = Moments(allveldata);
        allveldata = (allveldata - stats(h,end).velstats.mean')./stats(h,end).velstats.std';
        stats(h,end).velpdf.norm = GetPdf(allveldata,NBINS);

        % final PDF
        semilogy(stats(h,end).velpdf.norm(:,1),stats(h,end).velpdf.norm(:,2),'-','LineWidth',1.5);
        hold on;
        semilogy(stats(h,end).velpdf.norm(:,3),stats(h,end).velpdf.norm(:,4),'-','LineWidth',1.5);
        hold off;

        xlabel('Particle velocity, normalized [-]');
        ylabel('PDF');
        legend('Horizontal','Vertical','Location','northeast');
        title(sprintf('%s, T = [%.1f,%.1f]',group,stats(h,end).trh),'Interpreter','none');

        pause(2);
        
    end

end

% save the data
save(sprintf(OUTDATATEMPLATE,group),'stats');

end