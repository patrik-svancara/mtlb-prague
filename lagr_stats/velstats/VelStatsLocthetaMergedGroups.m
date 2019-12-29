function [allstats] = VelStatsLocthetaMergedGroups(groups,frrange,trhvec)
% Joined velocity statistics for groups of movies. Only points within some T-range and frame ranged are selected.
% INPUT:    groups:     string vector (length g) of group names
%           frrange:    (g × 2) vector of the considered frame ranges
%           trhvec:     (n × 2) vector of relevant T ranges
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
allstats(size(trhvec,1),length(groups)+1) = statsitem;


% load all considered data
MOVTEMPLATE = '../../../results/tracks/mov_%s.mat';
for g = 1:length(groups)
    
    fprintf('Loading group %d/%d\n',g,length(groups));
    
    load(sprintf(MOVTEMPLATE,groups(g)));
    gr(g).mov = mov;
    
end


% calculation for all T-threshold values
for h = 1:size(trhvec,1)
    
    % message to the user
    fprintf('*** Threshold %d/%d ***\n',h,size(trhvec,1));
      
    % save threshold vaues
    for m = 1:size(allstats,2)
        allstats(h,m).trh = trhvec(h,:);
    end
    
    %%% flag all movie groups %%%
    for g = 1:length(groups)
        
        fprintf('Flagging group %d/%d\n',g,length(groups));

	    allstats(h,g).group = groups(g);
        allstats(h,g).frrange = frrange(g,:);
        
        for m = 1:length(gr(g).mov)
            
            for t = 1:length(gr(g).mov(m).tr)
                
                % local theta flagging
                gr(g).mov(m).tr(t).thflag = and(trhvec(h,1) <= abs(gr(g).mov(m).tr(t).ltheta),...
                    abs(gr(g).mov(m).tr(t).ltheta) <= trhvec(h,2));
                
                % frrange flagging
                gr(g).mov(m).tr(t).frflag = and(frrange(g,1) <= gr(g).mov(m).tr(t).fr,...
                    gr(g).mov(m).tr(t).fr <= frrange(g,2));
                
                % both conditions must be fulfilled
                gr(g).mov(m).tr(t).flag = and(gr(g).mov(m).tr(t).thflag',gr(g).mov(m).tr(t).frflag);
                
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
        
        for m = 1:length(gr(g).mov)
            
            [~,~,veldata] = VelStatsFlagSingleMov(gr(g).mov(m),true);
            
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

            title(sprintf('Group %s, T = [%.1f,%.1f]',groups(g),allstats(h,g).trh),'Interpreter','none');
            
            pause(0.5);

        end
        
    end
    
    % allveldata statistics

	allstats(h,end).group = "ringall";
    
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

        title(sprintf('All groups, T = [%.1f,%.1f]',allstats(h,end).trh),'Interpreter','none');
        
        pause(0.5);
        
    end
    
end

end
