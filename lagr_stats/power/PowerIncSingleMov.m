function [allpwinc] = PowerIncSingleMov(mov,tsep)
% Runs PowerIncSingleTr for all trajectories and gathers useful
% (nonzero) data, for a single time step tsep.

% memory preallocation (overkilled due to short trajectories)
allpwinc = zeros(sum([mov.tr(:).length]),1);
allind = 1;

% for each trajectory
for t = 1:length(mov.tr)
    
    [pwinc,lenpwinc] = PowerIncSingleTr(mov.tr(t),tsep);
    
    if lenpwinc > 0
        
        % place increments to the main structure
        allpwinc(allind + (0:(lenpwinc-1))) = pwinc;
        
        % update position index
        allind = allind + lenpwinc;
        
    end
    
end

% check for the length of resulting vector
if allind == 1
    
    % no data, return NaN
    allpwinc = NaN;
    
else

    % trim allpwinc vector at the latest position
    allpwinc = allpwinc(1:allind-1);
    
end

end