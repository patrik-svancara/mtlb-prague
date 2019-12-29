function [spltr] = TrSplitSingleTr(tr,trhold)
% Splits a single trajectory into segments defined by treshold in physical
% units. Spltr is a 4-column vector [splitstart splitend length flag(is above trhold?)].

% check if diff is defined
if tr.truedifflength == 0
    
    spltr = [NaN NaN NaN NaN];
    
    return
    
end

%%% diff defined, we can split the trajectory %%%

% check treshold condition
% consistent sets of 1s or 0s will make the subtracks
trflag = (abs(tr.diff(:,2)) >= trhold);


% fragment count index
splitind = 1;

% there is an offset between diff and pos indices filled by NaNs
% in tr.diff
posoff = (tr.length - tr.truedifflength)/2;

% initial position indices
splitstart = 1+posoff;
splitend = 2;

while splitend <= (size(trflag,1) - posoff)
    
    if trflag(splitend) ~= trflag(splitstart)
        
        % when mismatch, create track fragment
        spltr(splitind,:) = [splitstart splitend-1 length(splitstart:splitend-1) trflag(splitstart)];
        
        % update indices
        splitstart = splitend;
        splitind = splitind + 1;
        
    end
    
    % update for another iteration
    splitend = splitend + 1;
    
end

% add last track fragment
spltr(splitind,:) = [splitstart splitend-1 length(splitstart:splitend-1) trflag(splitstart)];

end   