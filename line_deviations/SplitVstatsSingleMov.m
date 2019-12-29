function [strveldata,crvveldata] = SplitVstatsSingleMov(mov)
% Merges velstats from single trajectory data

%% Memory prealloc - find total number of segments

strcounts = 0;
crvcounts = 0;

for t = 1:length(mov.tr)
    
    if ~all(isnan(mov.tr(t).spltr))
    
        crvcounts = crvcounts + sum(mov.tr(t).spltr(:,4));
        strcounts = strcounts + (size(mov.tr(t).spltr,1)) - sum(mov.tr(t).spltr(:,4));
        
    end
    
end

% memory prealloc; +1 is due to segment lengths
strveldata = zeros(strcounts,size(mov.tr(1).vel,2)+1);
crvveldata = zeros(crvcounts,size(mov.tr(1).vel,2)+1);

%% Merge stats

strvelind = 1;
crvvelind = 1;

for t = 1:length(mov.tr)
    
    [strveltr,crvveltr] = SplitVstatsSingleTr(mov.tr(t));
    
    strveldata(strvelind + (0:size(strveltr,1)-1),:) = strveltr;
    strvelind = strvelind + size(strveltr,1);
    
    crvveldata(crvvelind + (0:size(crvveltr,1)-1),:) = crvveltr;
    crvvelind = crvvelind + size(crvveltr,1);
    
end

end