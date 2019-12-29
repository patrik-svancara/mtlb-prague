function [pwr] = PowerSingleTr(tr)
% Returns input power (dot product of velocity and acceleration) for the
% given trajectory as tr.pwr. Assumes tr.vel and tr.acc are of the same
% length tr.vlength = tr.alength.

if tr.vlength > 0
    
    pwr = dot(tr.vel(:,1:2),tr.acc(:,1:2),2);
    
else
    
    pwr = NaN;
    
end

end