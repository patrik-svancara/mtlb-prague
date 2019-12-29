function [mov] = RemoveEmptyTr(mov)
%RemoveEmptyTr Removes empty trajectories from movies
%   Removal of all trajectories that have zero length

for m = 1:length(mov)
    
    filt = [mov(m).tr(:).length] == 0;
    
    mov(m).tr = mov(m).tr(~filt);
    
end

end

