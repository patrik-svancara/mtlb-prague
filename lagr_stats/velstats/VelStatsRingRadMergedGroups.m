function [allstats] = VelStatsRingRadMergedGroups(groups,rings,frrange,radvec)
% Joined velocity statistics for groups of movies. Only points within distance from the ring center are considered.
% INPUT:    groups:     string vector (length g) of group names
%           rings:      struct vector (length g) of ring files
%           frrange:    (g × 2) vector of the considered frame ranges
%           radvec:     (n × 2) vector of radial distance ranges
%
% OUTPUT:   allstats:   (n × g+1) structure with results for single groups
%                       & merged data
% No files are saved automatically.

% number of histogram bins
NBINS = 400;

% add dependencies
addpath('../');
addpath('../../common/');

% preallocation of stats struct
statsitem = struct('velstats',[],'velpdf',[]);
allstats(size(radvec,1),length(groups)+1) = statsitem;

disp(size(allstats));


% load all considered data
MOVFRTEMPLATE = '../../../results/tracks/movfr_%s.mat';
for g = 1:length(groups)
    
    fprintf('Loading group %d/%d\n',g,length(groups));
    
    load(sprintf(MOVFRTEMPLATE,groups(g)));
    gr(g).movf = movf;
    
    gr(g).ring = rings(g);
    
end


% calculation for all radvec values
for h = 1:size(radvec,1)
    
    % message to the user
    fprintf('*** Radius %d/%d ***\n',h,size(radvec,1));
      
    % save radius range
    for m = 1:size(allstats,2)
        allstats(h,m).rad = radvec(h,:);
    end
    
    %%% flag all movie groups %%%
    for g = 1:length(groups)
        
        fprintf('Flagging group %d/%d\n',g,length(groups));
        
        allstats(h,g).frrange = frrange(g,:);
        
        % save group name
        allstats(h,g).group = groups(g);
        
        for m = 1:length(gr(g).movf)
            
            for f = 1:length(gr(g).movf(m).fr)
                
                % frrange flagging
                if and(frrange(g,1) <= f,f <= frrange(g,2))
                    
                    % check if both vortex positions are available
                    if ~isnan(gr(g).ring.diam(f,3))
                        
                        % calculate distance from both vortices
                        gr(g).movf(m).fr(f).dst(:,1) = ...
                            sqrt((gr(g).movf(m).fr(f).pos(:,1) - gr(g).ring.p.posx(f)).^2 + ...
                            (gr(g).movf(m).fr(f).pos(:,2) - gr(g).ring.p.posy(f)).^2);
                        
                        gr(g).movf(m).fr(f).dst(:,2) = ...
                            sqrt((gr(g).movf(m).fr(f).pos(:,1) - gr(g).ring.n.posx(f)).^2 + ...
                            (gr(g).movf(m).fr(f).pos(:,2) - gr(g).ring.n.posy(f)).^2);
                        
                        % both distances must be larger than lower bound
                        flaglow = gr(g).movf(m).fr(f).dst >= radvec(h,1);
                        flaglow = and(flaglow(:,1),flaglow(:,2));
                        
                        % one of the distances must be smaller than higher bound
                        flaghigh = gr(g).movf(m).fr(f).dst <= radvec(h,2);
                        flaghigh = or(flaghigh(:,1),flaghigh(:,2));
                        
                        % both conditions must be fulfilled
                        gr(g).movf(m).fr(f).flag = and(flaglow,flaghigh);
                    
                    else
                        
                        % ring is not defined -> false flag
                        gr(g).movf(m).fr(f).flag = false(gr(g).movf(m).fr(f).pts,1);
                        
                    end
                    
                else
                    
                    % outside frrange -> false flag
                    gr(g).movf(m).fr(f).flag = false(gr(g).movf(m).fr(f).pts,1);
                    
                end
                
            end
            
        end
        
    end
    
    %%% run velstat engine %%%
    
    % init all veldata
    allveldata = [ ];
    
    for g = 1:length(groups)
        
        fprintf('Velocity statistics for group %d/%d\n',g,length(groups));
        
        % init group veldata
        grveldata = [ ];
        
        for m = 1:length(gr(g).movf)
            
            [~,~,veldata] = VelStatsFlagSingleMovf(gr(g).movf(m),true);
            
            if ~isnan(veldata)
                
                grveldata = cat(1,grveldata,veldata);
                
            end
            
        end

        % group statistics
        if isempty(grveldata)

            % prepare null results
            allstats(h,g).velstats = Moments(NaN*ones(1,3));
            allstats(h,g).velstats.pts = zeros(1,3);

            allstats(h,g).velpdf.raw = NaN*ones(1,6);
            allstats(h,g).velpdf.norm = NaN*ones(1,6);

        else

            % merge with alldata
            allveldata = cat(1,allveldata,grveldata);

            % make statistics
            allstats(h,g).velstats = Moments(grveldata);
            allstats(h,g).velpdf.raw = GetPdf(grveldata,NBINS);

            grveldata = (grveldata - allstats(h,g).velstats.mean')./allstats(h,g).velstats.std';
            allstats(h,g).velpdf.norm = GetPdf(grveldata,NBINS);

            % plot PDFs
            semilogy(allstats(h,g).velpdf.norm(:,1),allstats(h,g).velpdf.norm(:,2),'-','LineWidth',1.5);
            hold on;
            semilogy(allstats(h,g).velpdf.norm(:,3),allstats(h,g).velpdf.norm(:,4),'-','LineWidth',1.5);
            hold off;

            xlabel('Normalized particle velocity [-]');
            ylabel('PDF [-]');

            title(sprintf('Group %s, r = [%.1f,%.1f]',groups(g),allstats(h,g).rad),'Interpreter','none');
            
            pause(0.5);

        end
        
    end
    
    % allveldata statistics
    allstats(h,end).group = "merged_groups";
    
    if isempty(allveldata)
        
        % prepare null results
        allstats(h,end).velstats = Moments(NaN*ones(1,3));
        allstats(h,end).velstats.pts = zeros(1,3);
        
        allstats(h,end).velpdf.raw = NaN*ones(1,6);
        allstats(h,end).velpdf.norm = NaN*ones(1,6);
        
    else
        
        % make statistics
        allstats(h,end).velstats = Moments(allveldata);
        allstats(h,end).velpdf.raw = GetPdf(allveldata,NBINS);

        allveldata = (allveldata - allstats(h,end).velstats.mean')./allstats(h,end).velstats.std';
        allstats(h,end).velpdf.norm = GetPdf(allveldata,NBINS);

        % plot PDFs
        semilogy(allstats(h,end).velpdf.norm(:,1),allstats(h,end).velpdf.norm(:,2),'-','LineWidth',1.5);
        hold on;
        semilogy(allstats(h,end).velpdf.norm(:,3),allstats(h,end).velpdf.norm(:,4),'-','LineWidth',1.5);
        hold off;

        xlabel('Normalized particle velocity [-]');
        ylabel('PDF [-]');

        title(sprintf('All groups, r = [%.1f,%.1f]',allstats(h,end).rad),'Interpreter','none');
        
        pause(0.5);
        
    end
    
end

end