function [velprof] = EVelProfileSingleGroup(group,movf)
% Pseudo-eulerian velocity profile

% prepare output folder
RESTEMPLATE = '../../../results/profile_res/%s/';
outfolder = sprintf(RESTEMPLATE,group);
if exist(outfolder,'dir') == 0
    
    mkdir(outfolder)
    
end

% outfile template
OUTFIGTEMPLATE = [outfolder 'velprof_%s.png'];
OUTDATATEMPLATE = [outfolder 'velprof_data_%s.mat'];

% load data if not provided by external parameter
if nargin == 1
    MOVFRTEMPLATE = '../../../results/tracks/movfr_%s.mat';
    load(sprintf(MOVFRTEMPLATE,group),'movf');
end

% key dimensions
VELDIM = size(movf(1).fr(1).vel,2);
NFRAMES = movf(1).caminfo.nframes;
NMOV = length(movf);

% legend template & legend
LEGTEMPLATE = ["Horizontal" "Vertical" "Absolute"];
lgnd = LEGTEMPLATE(1:VELDIM);

% preallocate output variables
profitem = struct('mvel',zeros(NFRAMES,VELDIM),'stdvel',zeros(NFRAMES,VELDIM),...
    'velpts',zeros(NFRAMES,1),'time',[]);
velprof(1:NMOV+1) = profitem;

% time vector
time = (0:NFRAMES-1)./movf(1).caminfo.fps.*1e3;

% through movies and frames
for m = 1:NMOV
    
    velprof(m).time = time;
    
    for f = 1:length(movf(m).fr)
        
        [velprof(m).mvel(f,:),velprof(m).stdvel(f,:),velprof(m).pts(f)] = ...
            EMeanVelSingleFr(movf(m).fr(f));
        
    end
    
end

% averaged profile as last struct element
for f = 1:NFRAMES
    
    mv = zeros(NMOV,VELDIM);
    mv2 = zeros(NMOV,VELDIM);
    wt = zeros(NMOV,1);
    
    for m = 1:NMOV
        
        mv(m,:) = velprof(m).mvel(f,:);
        mv2(m,:) = velprof(m).stdvel(f,:);
        wt(m) = velprof(m).pts(f);
        
    end
    
    velprof(end).pts(f) = sum(wt);
    
    % weighted average % standard deviation
    wt = wt./velprof(end).pts(f);
    velprof(end).mvel(f,:) = sum(mv.*wt,1);
    velprof(end).stdvel(f,:) = sqrt(sum(mv2.*wt,1) - velprof(end).mvel(f,:).^2);
    
end

velprof(end).time = time;

% parse structure once more to obtain standard deviations
for m = 1:NMOV
    
    for f = 1:NFRAMES
        
        velprof(m).stdvel(f,:) = sqrt(velprof(m).stdvel(f,:) - velprof(m).mvel(f,:).^2);
        
    end
end

% plot velocity profiles
plot(velprof(end).time,velprof(end).mvel,'-','LineWidth',1.5);
hold on;

% fill standard error area
COLS = lines(3);
for i = 1:VELDIM
    
    % trim to remove NaN
    mv = RemoveNaN(velprof(end).mvel(:,i));
    mve = RemoveNaN(velprof(end).stdvel(:,i));
    
    offset = (size(velprof(end).mvel,1) - size(mv,1))/2;
    time = velprof(end).time((offset+1):end-offset);
    
    % fill area
    fill([time,flip(time)],[mv+mve./2;flip(mv-mve./2)],COLS(i,:),'EdgeColor','none','FaceAlpha',0.2);
end

hold off;

xlabel('Time [ms]');
ylabel('Mean velocity [mm/s]');

grid on;

legend(lgnd,'Location','northwest');
title(group,'Interpreter','none');

% save figure
pause(0.5);
print(gcf,'-dpng',sprintf(OUTFIGTEMPLATE,group));

% save the data
save(sprintf(OUTDATATEMPLATE,group),'velprof');

end