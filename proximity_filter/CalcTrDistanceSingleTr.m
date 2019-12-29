function [dst] = CalcTrDistanceSingleTr(tr,trind)
%CalcTrDistanceSingleTr Mean distance between tr(trind) and tr array

addpath('../common/');

dst = zeros(length(tr),1);

% frame range of tr(trind)
frrange = tr(trind).fr([1 end]);

for t = 1:length(tr)
    
    % check if tr overlaps with tr(trind)
    overlap = tr(t).fr >= frrange(1) & tr(t).fr <= frrange(2);
    
    if any(overlap)
        
        % overlapping frames
        overframes = tr(t).fr(overlap);
        
        % calculate distance for overlapping frames
        overdst = norm(tr(t).pos(overlap,:) - tr(trind).pos(any(tr(trind).fr == overframes'),:));
        
        % mean distance
        dst(t) = mean(overdst);
        
    else
        
        dst(t) = NaN;
        
    end
    
end

% Replace self-distance with NaN
dst(trind) = NaN;

end
    
    