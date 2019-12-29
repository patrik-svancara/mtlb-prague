function [tr] = AccelerationProjection(tr)
% Calculates longitudinal and transversal acceleration with respect to
% the velocity vector. Assumes tr.vel and tr.acc are of the same length
% and their 3rd columns contain vel and acc norms.
% Adds 4th and 5th column to tr.acc vector.

if tr.alength > 0

    % longitudinal increment projected to the velocity direction
    tr.acc(:,4) = dot(tr.acc(:,1:2),(tr.vel(:,1:2)./tr.vel(:,3)),2);

    % transversal increment from cross product
    tr.acc(:,5) = tr.acc(:,1).*(tr.vel(:,2)./tr.vel(:,3)) - tr.acc(:,2).*(tr.vel(:,1)./tr.vel(:,3));
    
else
    
    tr.acc(4:5) = [NaN NaN];
    
end

end