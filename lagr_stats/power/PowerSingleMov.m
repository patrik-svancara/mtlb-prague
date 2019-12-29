function [allpwr]  = PowerSingleMov(mov)
% Calculates input power for each trajectory and obtains coarse-grained
% power data for further statistical analysis.

% memory prealloc
allpwr = zeros(sum([mov.tr(:).vlength]),1);
allpwrind = 1;

for t = 1:length(mov.tr)
    
    % vlength is the same as power vector length
    if mov.tr(t).vlength > 0
        
        % fill coarse-grained data vector
        allpwr(allpwrind + (0:(mov.tr(t).vlength-1)),:) = PowerSingleTr(mov.tr(t));
        
        % update position index
        allpwrind = allpwrind + mov.tr(t).vlength;
        
    end
    
end

end