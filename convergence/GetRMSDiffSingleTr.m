function [veldiff,accdiff] = GetRMSDiffSingleTr(oldtr,newtr)
% Calculates the difference between velocity (acceleration) points for a
% given pair of tracks. Assumes that newtr is genrally shorter than oldtr

% velocity difference
if newtr.vlength > 0
    
    % velocity offset
    veloff = (oldtr.vlength - newtr.vlength)/2;
    
    % velocity difference
    veldiff = newtr.vel - oldtr.vel(veloff+1:end-veloff,:);
    
    % remove NaN values, if there are any
    veldiff = RemoveNaN(veldiff);
    
else
    
    veldiff = NaN;
    
end

% acceleration difference
if newtr.alength > 0
    
    % acceleration offset
    accoff = (oldtr.alength - newtr.alength)/2;
    
    % acceleration difference
    accdiff = newtr.acc - oldtr.acc(accoff+1:end-accoff,:);
    
    % remove NaN values, if there are any
    accdiff = RemoveNaN(accdiff);
    
else
    
    accdiff = NaN;
    
end

end