function [vx,vy,sqvx,sqvy,pts] = GrToMaps(gr)
% Preparation for drawing intensity maps

% memory preallocation
vx = zeros(size(gr))';
vy = vx;
sqvx = vx;
sqvy = vx;
pts = vx;   

for i = 1:size(gr,1)
    
    for j = 1:size(gr,2)
        
        % outputs are transposed so that
        % 1st index = row count = vertical coordinate
        % 2nd index = col count = horizotnal coordinate
        
        vx(j,i) = gr(i,j).vel(1);
        vy(j,i) = gr(i,j).vel(2);
        
        sqvx(j,i) = gr(i,j).sqvel(1);
        sqvy(j,i) = gr(i,j).sqvel(2);
        
        pts(j,i) = gr(i,j).pts;
        
    end
end

end