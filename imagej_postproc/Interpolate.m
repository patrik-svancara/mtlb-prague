function [posOut,frOut,intFlg] = Interpolate(posIn,frIn)
% Linear interpolation of 2-dim position vector

% output should be sampled equidistantly
frOut = frIn(1):frIn(end);

% same length means there is no need for interpolation
if length(frOut) == length(frIn)
    
    posOut = posIn;
    intFlg = false(size(frOut));
    
    return
    
end

% different length means we need interpolate
intFlg = true(frOut(end),1);

% prealloc output position, start from frame 1
posOut = zeros(frOut(end),size(posIn,2));

% fill in known positions
posOut(frIn,:) = posIn;

% mark them as not interpolated
intFlg(frIn) = false;

% find zero positions, to be interpolated
filt = posOut(frOut,1) == 0;

% interpolate missing positions
posOut(frOut(filt),:) = interp1(frIn,posIn,frOut(filt));

% trim posOut to start from first frame with data
posOut = posOut(frOut,:);

% trim intFlg as well
intFlg = intFlg(frOut);

end
