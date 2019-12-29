function [ ] = TracksToMovie(moviename,mov,movf)
% Camera frames are overlapped with tracked positions.
% Inidvidual frames are saved.

% template for image file names
IMGTEMPLATE = '../../movies/proc_movies/%1$s/%1$s-fr%2$04d.tif';

% prepare output folder
RESTEMPLATE = '../../results/video_tracked/%s/';
outfolder = sprintf(RESTEMPLATE,moviename);
if exist(outfolder,'dir') == 0
    
    mkdir(outfolder)
    
end

OUTIMGTEMPLATE = [outfolder '%s-frplus%04d.tif'];

% define available colors
allcolornum = 16;
col = hsv(allcolornum);

% define field of view, in milimeters
fov = [mov.caminfo.resx mov.caminfo.resy].*mov.scfactor./1e3;

% define colormap & predefine figure size
colormap gray;
set(gcf,'rend','painters','Position',[10 10 912 800]);

% through all current frames
for currfr = 1:1e3
    
    % load & flip image to start from bottom left
    im = flip(imread(sprintf(IMGTEMPLATE,moviename,currfr)),1);
    
    % plot the image
    image([0 fov(1)],[0 fov(2)],im);
    axis xy;
    
    % correct plot box aspect ratio
    pbaspect([1.14 1 1]);
    
    hold on;
    
    % plot circles around particles in current frame
    % colors assigned accordingly to trajectory index
    scatter(movf(1).fr(currfr).pos(:,1),movf(1).fr(currfr).pos(:,2),20,...
        col(mod(movf(1).fr(currfr).tr,allcolornum)+1,:));
    
    % add line plots of individual trajectories
    for usedtraj = 1:length(movf(1).fr(currfr).tr)
        
        usedtrajind = movf(1).fr(currfr).tr(usedtraj);
        
        % find index until which I plot the trajectory
        currendpos = find(mov(1).tr(usedtrajind).fr == currfr,1);
        
        % plot trajectory segment and use the same color as for scatter
        plot(mov(1).tr(usedtrajind).pos(1:currendpos,1),...
            mov(1).tr(usedtrajind).pos(1:currendpos,2),...
            '-','Color',col(mod(usedtrajind,allcolornum)+1,:));
        hold on;
        
    end
    
    hold off;
    
    xlabel('Horizontal position [mm]');
    ylabel('Vertical position [mm]');
    title(sprintf('Movie %s, frame %d',moviename,currfr),'Interpreter','none');
    
    % for the user to look
    pause(0.3);
    
    % save frame by frame
    print(sprintf(OUTIMGTEMPLATE,moviename,currfr),'-dtiff');
    
end

end