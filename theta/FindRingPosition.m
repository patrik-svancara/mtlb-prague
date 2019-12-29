function [ring] = FindRingPosition(gr,seqtheta,trhold)
% Finds the position of the vorticity centroid, as function of time.
% gr - mesh grid positions
% seqtheta - sequence of theta slides
% trhold - treshold to cut the positive hill / negative valley

% calculate the pixel size
PIXAREA = (gr.posx(1,2) - gr.posx(1,1))*(gr.posy(2,1) - gr.posy(1,1));
% PIXAREA = 0.0469; % 1 pixel area, in square millimiters

% hill / pit discrimination based on trhold sign
if sign(trhold) == 1
    
    % look for hill
    ringfilter = seqtheta >= trhold;
    
else
    
    % look for valley
    ringfilter = seqtheta <= trhold;
    
end

% theta sequence containing only the ring
ring.data = seqtheta.*double(ringfilter);

% size of the ring (area of pixels that meet the hill / valley criterion)
ring.size = sum(sum(ringfilter,2),3).*PIXAREA;

% weight of the ring (sum of thetas inside the selected area)
ring.wt = sum(sum(ring.data,2),3);

% centroid x and y positions
ring.posx = sum(sum(ring.data.*reshape(gr.posx,[1 size(gr.posx)]),2),3)./ring.wt;
ring.posy = sum(sum(ring.data.*reshape(gr.posy,[1 size(gr.posy)]),2),3)./ring.wt;

end