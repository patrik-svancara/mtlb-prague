function [strveldata,crvveldata] = SplitVstatsSingleTr(tr)
% Calculates, for each straight / curved segment of a trajectory their
% respective mean velocities along the segments. Last column maps the
% length of the segments.

nodata = NaN*ones(1,size(tr.vel,2)+1    );

% assume there are no data
strveldata = nodata;
crvveldata = nodata;

% if there are no data, return
if all(isnan(tr.spltr))
    return
end

% if there are some data, find out how many segments are to be processed
crvcount = sum(tr.spltr(:,4));
strcount = size(tr.spltr,1) - crvcount;

if strcount > 0
    
    % prealloc memory
    strveldata = zeros(strcount,size(tr.vel,2)+1);
    
    % init index
    strvelind = 1;
    
end

if crvcount > 0
   
    % prealloc memory
    crvveldata = zeros(crvcount,size(tr.vel,2)+1);
    
    % init index
    crvvelind = 1;
    
end

% fill with data
for s = 1:size(tr.spltr,1)
    
    % segment index vector
    segmentind = tr.spltr(s,1):tr.spltr(s,2);
    
    % if true, segment is curved
    if tr.spltr(s,4)
        
        crvveldata(crvvelind,:) = [mean(tr.vel(segmentind,:),1) tr.spltr(s,3)];
        
        crvvelind = crvvelind + 1;
        
    % if false, segment is straight
    else
        
        strveldata(strvelind,:) = [mean(tr.vel(segmentind,:),1) tr.spltr(s,3)];
        
        strvelind = strvelind + 1;
        
    end
    
end

end

