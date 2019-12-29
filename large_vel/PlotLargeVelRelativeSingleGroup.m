function [largevel] = PlotLargeVelRelativeSingleGroup(group,ringfile,vellim,veldir)

% load data
load("../../results/tracks/movfr_"+group+".mat",'movf');
load("../../results/theta_res/ring/"+ringfile,'ring');
load(sprintf('../../results/lagr_res/%1$s/velstat_data_%1$s.mat',group),'stats');

% make output folder
OUTFOLDER_TEMPLATE = '../../results/large_vel_res/%s/';
outfolder = sprintf(OUTFOLDER_TEMPLATE,group);
if exist(outfolder,'dir') == 0
    mkdir(outfolder)
end

% output file templates
OUTFILE_TEMPLATE = 'large_vel_data_veldir%d_vellim%.1f_%s.mat';
OUTFIG_TEMPLATE = 'large_vel_pos_veldir%d_vellim%.1f_%s.png';


% filter frames with both ring positions
frames = 1:length(movf(1).fr);
frames = frames(and(~isnan(ring.a.posx),~isnan(ring.a.posy)));

% calculate raw velocity limits
vel_max = vellim * stats(end).velstats.std(veldir) + stats(end).velstats.mean(veldir);
vel_min = -vellim * stats(end).velstats.std(veldir) + stats(end).velstats.mean(veldir);

% init output struct
largevel = struct;

largevel.frames = frames;
largevel.veldir = veldir;
largevel.vellim = vellim;
largevel.vel_min = vel_min;
largevel.vel_max = vel_max;

largevel.hit = struct;
hitcnt = 1;

% process the data
for m = 1:length(movf)
    
    for f = frames
        
        filt = or(movf(m).fr(f).vel(:,veldir) < vel_min,movf(m).fr(f).vel(:,veldir) > vel_max);
        
        if sum(filt) > 0
            
            % save relevant data
            largevel.hit(hitcnt).mov = m;
            largevel.hit(hitcnt).fr = f;
            largevel.hit(hitcnt).pos = movf(m).fr(f).pos(filt,:);
            largevel.hit(hitcnt).vel = movf(m).fr(f).vel(filt,:);
            largevel.hit(hitcnt).acc = movf(m).fr(f).acc(filt,:);
            largevel.hit(hitcnt).tr = movf(m).fr(f).tr(filt);
            
            hitcnt = hitcnt + 1;
            
            % display large velocity events
            scatter(movf(m).fr(f).pos(filt,1) - ring.a.posx(f),...
                movf(m).fr(f).pos(filt,2) - ring.a.posy(f),'r.');
            
            hold on;
        
        end
        
    end
    
end

box on;
grid on;

% plot the mean ring diameter as a line
diam = mean(ring.diam(frames,3));
diamline = line([-diam/2 diam/2],[0 0]);
diamline.Color = 'k'; diamline.LineWidth = 2;

xlabel('Horizontal distance from the ring [mm]');
ylabel('Vertical distance from the ring [mm]');

title(group,'Interpreter','none');

hold off;

pause(0.5);

% print the figure
print(gcf,'-dpng',outfolder+"/"+sprintf(OUTFIG_TEMPLATE,veldir,vellim,group));

% save the data
save(outfolder+"/"+sprintf(OUTFILE_TEMPLATE,veldir,vellim,group),'largevel');

end