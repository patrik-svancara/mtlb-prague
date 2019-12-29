function [elimflag] = EliminateShorterTrack(tr,trind, trhold)
%EliminateShorterTrack Flags trajectory for elimination, if the nearest trajectory is longer than given trajectory.

% default value
elimflag = false;

% check elimination threshold
[mval,mind] = min(tr(trind).dst);

if mval <= trhold
    
    % compare lengths (remove both if their length is the same)
    if tr(trind).length <= tr(mind).length
        
        elimflag = true;
        
    end
    
end

end