function [tr] = VelocityAbsolute(tr)
% Add 3rd column to tr.vel with velocity magnitude.

if tr.vlength > 0
    
    tr.vel(:,3) = sqrt(tr.vel(:,1).^2 + tr.vel(:,2).^2);
    
else
    
    tr.vel(3) = NaN;
    
end

end