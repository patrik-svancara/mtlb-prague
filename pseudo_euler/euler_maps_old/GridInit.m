function [gr] = GridInit(nbins,fovsize)
% Pseudo-Eulerian grid initialization.
% Returns gr struct - 2-D grid with fields:
%       - vel: velocity points (to be averaged)
%       - pts: number of points per bin           

% single grid item struct
gritem = struct('vel',[0 0 0],'sqvel',[0 0 0],'pts',0,'boxstart',[0 0],'boxend',[0 0]);

% 1st index = horizontal direction
% 2nd index = vertical direction
gr(1:nbins(1),1:nbins(2)) = gritem;

grsize = size(gr);
gritemsize = fovsize./grsize;

for i = 1:grsize(1)
    
    for j = 1:grsize(2)
        
        % obtain limits of the boxes
        gr(i,j).boxstart = [(i-1) (j-1)].*gritemsize;
        gr(i,j).boxend = [i j].*gritemsize;
        
    end
    
end