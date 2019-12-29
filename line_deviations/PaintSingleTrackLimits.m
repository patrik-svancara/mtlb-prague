function [ ] = PaintSingleTrackLimits(tr,tsep,direction,colorlims)
% Calculates diff of the trajectory, then plots its time-dependent
% horiz./vert. position in a color-coded scatter plot.
% Color coding is based on abs. value of diff and maps the colors on a
% discrete set of groups specified by colorlims

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

% map diff(:,2) values on colorlims indices
diffind = interp1(colorlims,1:length(colorlims),abs(diff(:,2)),'previous','extrap');

% obtain colors
allcolors = hsv(length(colorlims));

for d = 1:length(diffind)
    
    if ~isnan(diffind(d))
        plotcolors(d,:) = allcolors(diffind(d),:);
    else
        plotcolors(d,:) = [NaN NaN NaN];
    end
end

% make the plot colored strictly by vertical deviations
scatter(1:tr.length,tr.pos(:,dirind),10,plotcolors,'o','filled');
axis auto;

xlabel('Time [frames]');
ylabel([dirlbl 'position [mm]']);

end