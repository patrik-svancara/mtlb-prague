function [stats] = VelStatsRingRadSingleGroup(meta,radvec,ring)
% Calculates velocity statistics for a group of movies, with respect to the distance between the particle and center of vortex ring.
% radvec is the n×2 vector of considered distance limits, in millimeters.
% Returns stats (n×(length(mov)+1) structure and saves the results.
% No figures are saved automatically.

% add dependencies
addpath('../');
addpath('../../common/');

% prepare output folder
RESTEMPLATE = '../../../results/lagr_res/%s/';
outfolder = sprintf(RESTEMPLATE,meta.group);
if exist(outfolder,'dir') == 0
    
    mkdir(outfolder)
    
end

% outfile template
OUTDATATEMPLATE = [outfolder 'velstatrad_radvec_data_%s.mat'];

% load movie
MOVFRTEMPLATE = '../../../results/tracks/movfr_%s.mat';
load(sprintf(MOVFRTEMPLATE,meta.group));

MOVTEMPLATE = '../../../results/tracks/mov_%s.mat';
load(sprintf(MOVTEMPLATE,meta.group));

% load ring data
% RINGTEMPLATE = '../../../results/theta_res/ring/%s';
% load(sprintf(RINGTEMPLATE,meta.ringfile));

% preallocation of stats struct (for each radius and movie + mean across movies)
statsitem = struct('velstats',[],'velpdf',[]);
stats(size(radvec,1):length(mov)+1) = statsitem;

% for all radius values
for h = 1:size(radvec,1)
    
    % message to the user
    fprintf('*** Radius %d/%d ***\n',h,size(radvec,1));
    
    % save radius vaues
    for m = 1:size(stats,2)
        stats(h,m).rad = radvec(h,:);
    end
    
    % flag the data
    for m = 1:length(movf)

        for f = 1:length(movf(m).fr)
            
            % check if both vortex positions are available
            if ~isnan(ring.diam(f,3))
                
                % calculate distances from both vortices
                movf(m).fr(f).dst(:,1) = ...
                    sqrt((movf(m).fr(f).pos(:,1) - ring.p.posx(f)).^2 + ...
                         (movf(m).fr(f).pos(:,2) - ring.p.posy(f)).^2);
                     
                     
                movf(m).fr(f).dst(:,2) = ...
                    sqrt((movf(m).fr(f).pos(:,1) - ring.n.posx(f)).^2 + ...
                         (movf(m).fr(f).pos(:,2) - ring.n.posy(f)).^2);
                     
                % both distances must be larger than lower bound
                flaglow = movf(m).fr(f).dst >= radvec(h,1);
                flaglow = and(flaglow(:,1),flaglow(:,2));

                % one of the distances must be smaller than higher bound
                flaghigh = movf(m).fr(f).dst <= radvec(h,2);
                flaghigh = or(flaghigh(:,1),flaghigh(:,2));

                % both conditions must be fulfilled
                movf(m).fr(f).flag = and(flaglow,flaghigh);
                
            else
                
                movf(m).fr(f).flag = false(movf(m).fr(f).pts,1);

            end
        
        end
        
        % reconstruct flag to the mov structure
        for t = 1:length(mov(m).tr)
        
            for i = 1:mov(m).tr(t).length
            
                fi = (movf(m).fr(mov(m).tr(t).fr(i)).tr == t);
                mov(m).tr(t).flag(i) = movf(m).fr(mov(m).tr(t).fr(i)).flag(fi);
            
            end
        end
    end

    % init of total data vector
    allveldata = [ ];
    
    % through all movies
    for m = 1:length(mov)
        
        % message to the user
        fprintf('Processing run %d/%d\n',m,length(mov));
        
        [stats(h,m).velstats,stats(h,m).velpdf,veldata] = VelStatsFlagSingleMov(mov(m),true);
        
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
            
            title(sprintf('Run %d/%d, T = [%.1f,%.1f]',m,length(mov),stats(h,m).rad));
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
        stats(h,end).velpdf.raw = GetPdf(allveldata,400);
        
        stats(h,end).velstats = Moments(allveldata);
        allveldata = (allveldata - stats(h,end).velstats.mean')./stats(h,end).velstats.std';
        stats(h,end).velpdf.norm = GetPdf(allveldata,400);

        % final PDF
        semilogy(stats(h,end).velpdf.norm(:,1),stats(h,end).velpdf.norm(:,2),'-','LineWidth',1.5);
        hold on;
        semilogy(stats(h,end).velpdf.norm(:,3),stats(h,end).velpdf.norm(:,4),'-','LineWidth',1.5);
        hold off;

        xlabel('Particle velocity, normalized [-]');
        ylabel('PDF');
        legend('Horizontal','Vertical','Location','northeast');
        title(sprintf('%s, T = [%.1f,%.1f]',meta.group,stats(h,end).rad),'Interpreter','none');

        pause(2);
        
    end

end

% save the data
save(sprintf(OUTDATATEMPLATE,meta.group),'stats');

end