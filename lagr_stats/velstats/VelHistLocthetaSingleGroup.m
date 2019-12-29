function [histmap] = VelHistLocthetaSingleGroup(group,thrange,velrange,veldim,thnorm,velnorm)
% Returns the 2D histogram of velocity-theta distribution.
% Theta and velocity are normalized by normalization factors thnorm and velnorm.
% Histogram bins are specified by vectors thrange and velrange.
% Velocity dimension is specified by veldim (1=horizontal, 2=vertical, 3=absolute).
% Assumes the tracks have their local theta values assigned (mov(m).tr(t).ltheta).
% Output object, histmap, is a structure containing:
%   histmap.thrange
%   histmap.velrange
%   histmap.veldim
%   histmap.map (map of absolute counts)
%   histmap.nmap (normalized to a 2D-PDF of unitary area)

% handling of the optional parameters
if nargin == 4
    thnorm = 1;
    velnorm = 1;
end

% prepare output folder
RESTEMPLATE = '../../../results/lagr_res/%s/';
outfolder = sprintf(RESTEMPLATE,group);
if exist(outfolder,'dir') == 0
    
    mkdir(outfolder)
    
end

% outfile template
OUTFIGTEMPLATE = [outfolder 'histmap_vel%d_m%dx%d_%s.png'];
OUTDATATEMPLATE = [outfolder 'histmap_vel%d_m%dx%d_data_%s.mat'];

% load data
MOVFRTEMPLATE = '../../../results/tracks/mov_%s.mat';
load(sprintf(MOVFRTEMPLATE,group),'mov');

% prealloc the struct
histmap.thrange = thrange;
histmap.velrange = velrange;
histmap.veldim = veldim;
histmap.thnorm = thnorm;
histmap.velnorm = velnorm;
histmap.map = zeros(length(velrange)-1,length(thrange)-1);
histmap.nmap = zeros(size(histmap.map));

% through the movies
for m = 1:length(mov)
    
    % message to the user
    fprintf('Processing movie %d/%d\n',m,length(mov));
    
    % through the tracks
    for t = 1:length(mov(m).tr)
        
        %disp(t);
        % only tracks with data are accounted for
        if mov(m).tr(t).length > 0
            
            % position in velocity dim
            posvel = interp1(velrange,1:numel(velrange),mov(m).tr(t).vel(:,veldim)./velnorm,'previous',NaN);
            
            % position in theta dim
            postheta = interp1(thrange,1:numel(thrange),abs(mov(m).tr(t).ltheta)./thnorm,'previous',NaN)';
            
            % data which fit both thrange and velrange
            idx = 1:mov(m).tr(t).length;
            idx = idx(~or(isnan(posvel),isnan(postheta)));
            
            % add data to the map         
            for i = 1:length(idx)
                
                histmap.map(posvel(idx(i)),postheta(idx(i))) = histmap.map(posvel(idx(i)),postheta(idx(i))) + 1;
                
            end
            
        end
        
    end
    
end

% map normalization
elemarea = (velrange(end)-velrange(1))*(thrange(end)-thrange(1))/numel(histmap.map);
histmap.nmap = histmap.map./(elemarea*sum(sum(histmap.map)));

% plot for the user
i = imagesc([thrange(1) thrange(end)],[velrange(1) velrange(end)],log10(histmap.nmap));
set(i,'AlphaData',~(histmap.nmap == 0));
axis xy;
c = colorbar;
set(get(c,'title'),'string','log_{10}(PDF)');
xlabel('Normalized T');
ylabel('Normalized particle velocity');

print(gcf,'-dpng',sprintf(OUTFIGTEMPLATE,veldim,length(velrange),length(thrange),group));

% save the data
save(sprintf(OUTDATATEMPLATE,veldim,length(velrange),length(thrange),group),'histmap');

end