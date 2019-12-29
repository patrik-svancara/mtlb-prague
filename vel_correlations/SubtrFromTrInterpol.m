function [outvel] = SubtrFromTrInterpol(tr,gr)
% Removes pseudo-Eulerian quantity (e.g. mean velocity) from single track.
% gr must be pseudo-Eulerian gr structure, relevant qty is qu
% interpolated.

if or(tr.length == 0,tr.vlength == 0)
    
    % not enough data
    outvel = [NaN NaN];
    return

end

% interploate in both directions
outvel(:,1) = tr.vel(:,1) - interp2(gr.X,gr.Y,gr.VX,tr.pos(:,1),tr.pos(:,2),'spline');
outvel(:,2) = tr.vel(:,2) - interp2(gr.X,gr.Y,gr.VY,tr.pos(:,1),tr.pos(:,2),'spline');

% discard trajectories out-of-grid (should not happen, though)
if any(any(isnan(outvel)))
    
    outvel = [NaN NaN];
    
end

end