function [outvel] = SubtrFromTr(tr,gr,qty)
% Removes pseudo-Eulerian quantity (e.g. mean velocity) from single track.
% gr must be pseudo-Eulerian gr structure.

if or(tr.length == 0,tr.vlength == 0)
    
    % not enough data
    outvel = [NaN NaN];
    return

end

% memory prealloc
outvel = zeros(size(tr.vel));

% limits of the grid (assumes that the positions start at [0 0])
maxlim = gr(end,end).boxend;

% transform tr.pos into grid indices
grind = int32(ceil(tr.pos./maxlim.*size(gr)));

% remove the desired quantity point by point, based on particle position
for i = 1:tr.length
    
    g1 = grind(i,1);
    g2 = grind(i,2);
    
    switch qty
            
        % remove mean velocity
        case 'mean'
            outvel(i,:) = tr.vel(i,:) - gr(g1,g2).vel;
                
        % remove standard deviation
        case 'std'
            outvel(i,:) = tr.vel(i,:) - sqrt(gr(g1,g2).sqvel - gr(g1,g2).vel.^2);
            
        case 'rms'
            outvel(i,:) = tr.vel(i,:) - stqt(gr(g1,g2).sqvel);
            
    end
    
end

% discard trajectories out-of-grid
if any(any(isnan(outvel)))
    
    outvel = [NaN NaN];
    
end

end