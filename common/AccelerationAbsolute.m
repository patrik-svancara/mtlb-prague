function [tr] = AccelerationAbsolute(tr)
% Add 3rd column to tr.acc with acceleration magnitude.

if tr.alength > 0
    
    tr.acc(:,3) = sqrt(tr.acc(:,1).^2 + tr.acc(:,2).^2);
    
else
    
    tr.acc(3) = NaN;
    
end

end