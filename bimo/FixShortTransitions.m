function [nsg,nclass] = FixShortTransitions(tr,fixlen,off)
% takes tr.sg segments and removes all transitions of max length equal to
% fixlen, which precede and follow the same track type (including
% transition of opposite type).

% check for short transition segments
shortseg = and(tr.sg(:,4) <= fixlen,abs(tr.sg(:,1)) == 1);

% does the preceding and following segments match?
matchseg = tr.sg(1:end-2,1) == tr.sg(3:end,1);

% fill up false for first and last segment
matchseg = [false; matchseg; false];

segtofix = and(shortseg,matchseg);

if sum(segtofix) == 0
    
    % nothing to fix
    nsg = tr.sg;
    nclass = tr.class;
    return
    
end

% go through segments and fix the class vector (MUCH easier than
% reconstructing the segments)
nclass = zeros(tr.alength,1);

% first segment (always false for fixing) added manually
nclass(tr.sg(1,2):tr.sg(1,3)) = tr.sg(1,1);

for s = 2:size(tr.sg,1)
    
    if segtofix(s)
        
        % segment to fix => use previous class type
        thisclass = tr.sg(s-1,1);
        
    else
        
        % segment if ok => use current class type
        thisclass = tr.sg(s,1);
        
    end
    
    nclass(tr.sg(s,2):tr.sg(s,3)) = thisclass;
    
end

% run segmentation again
tr.class = nclass;
nsg = DissectTracksHypeSingleTr(tr,off);

end
