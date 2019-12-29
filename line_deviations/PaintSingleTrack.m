function [ ] = PaintSingleTrack(tr,tsep,direction,colorlims)
% Calculates diff of the trajectory, then plots its time-dependent
% horiz./vert. position in a color-coded scatter plot.
% User can optionally set the color limits to be used for the caxis.

switch direction
    
    case 'x'
        dirind = 1;
        dirlbl = 'Horizontal';
        
    case 'y'
        dirind = 2;
        dirlbl = 'Vertical';
        
end

% calculate position differences
diff = LineDevSingleTrack(tr,tsep);

% make the plot colored strictly by vertical deviations
scatter(1:tr.length,tr.pos(:,dirind),10,diff(:,2),'o','filled');

if nargin == 3
    % auto colormap
    caxis auto;
else
    caxis(colorlims);
end

c = colorbar;
set(get(c,'Label'),'String','Vertical deviation [mm]');
xlabel('Time [frames]');
ylabel([dirlbl 'position [mm]']);

end