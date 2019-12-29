function [diff] = SplineDevSingleTrack(tr,tsep)
% Returns trajectory differences from spline interpolated track.
% (1) "Dilute" track points with step tsep
% (2) Interplate missing points with smooth cubic splines.
% (3) Obtain differences between smooth and measured track.

% track must be at least tsep + 1 long
if tr.length <= tsep
    
    diff = NaN;
    return
    
end

% cutoff length
lmax = tr.length - mod((tr.length - 1),tsep);

% memory prealloc
diff = zeros(lmax,2);

% interpolate positions in both directions
intpos = interp1(1:tsep:lmax,tr.pos(1:tsep:lmax,:),1:lmax,'spline');

% differences
for i = 1:lmax
    diff(i,:) = tr.pos(i,:) - intpos(i,:);
end

% replace zeros due to match with interpolation points by NaN
diff(1:tsep:lmax,:) = NaN*diff(1:tsep:lmax,:);

% remove these events
diff = RemoveNaN(diff);

end
