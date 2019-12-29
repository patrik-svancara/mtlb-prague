function [X,Y,VX,VY] = GrToMesh(gr)
% Converts gr structure into matrices of X,Y points and VX,VY velocities.

% horizontal coords
for i = 1:size(gr,1)
    x(i) = mean([gr(i,1).boxstart(1) gr(i,1).boxend(1)]);
end

% vertical coords
for j = 1:size(gr,2)
    y(j) = mean([gr(1,j).boxstart(2) gr(1,j).boxend(2)]);
end


[X,Y] = meshgrid(x,y);

% velocity maps
[VX,VY,~,~,~] = GrToMaps(gr);

end