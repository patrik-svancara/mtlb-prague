function [posOut,frOut,intFlg] = Interpolate(posIn,frIn)
% Linear interpolation of 2-dim position vector

% output should be sampled equidistantly
frOut = frIn(1):frIn(end);

% same length means there is no need for interpolation
if length(frOut) == length(frIn)
    
    posOut = posIn;
    intFlg = false;
    
    return
    
end

% different length means we need interpolate
intFlg = true;

% prealloc output position, start from frame 1
posOut = zeros(frOut(end),size(posIn,2));

% fill in known positions
posOut(frIn,:) = posIn;

% find zero positions, to be interpolated
filt = posOut(frOut,1) == 0;

% interpolate missing positions
posOut(frOut(filt),:) = interp1(frIn,posIn,frOut(filt));

% trip posOut to start from first frame with data
posOut = posOut(frOut,:);

end
