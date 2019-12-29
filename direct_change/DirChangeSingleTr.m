function [theta] = DirChangeSingleTr(tr,tsep)
% Returns vector of directional angles from a single trajectory and for a
% single time step tsep.

% check trajectory length
if (tr.length <= 2*tsep)
    
    theta = NaN;
    return
    
end

% memory prealloc
theta = zeros(tr.length - 2*tsep,1);

for i = 1:(tr.length - 2*tsep)
    
    earlydiff = tr.pos(i+tsep,:) - tr.pos(i,:);
    latediff = tr.pos(i+2*tsep,:) - tr.pos(i+tsep,:);
    
    % cos(theta)
    theta(i) = dot(earlydiff,latediff)/(norm(earlydiff)*norm(latediff));
    
end

% theta from 0 to pi
theta = acos(theta);

% due to rounding errors, theta can become complex
theta = real(theta);

end
