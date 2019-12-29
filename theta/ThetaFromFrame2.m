function [theta] = ThetaFromFrame2(fr,gr,RAD_MIN,RAD_MAX)
% Returns a mesh of theta parameters, calculated for the given frame fr.
% Inspection areas are annula of inner radius RAD_MIN and outer radius RAD_MAX.

% if no data are found in the frame
if fr.pts == 0
    
    theta = zeros(size(gr.posx));
    return
    
end

% SCALING POWER (set to 2 for classical theta calculation)
SCPWR = 2;

% memory prealloc
pttheta = zeros([size(gr.posx) fr.pts]);

% for all particles
for p = 1:fr.pts
    
    % Carteasian distance mesh
    ptgr(p).dstx = gr.posx - fr.pos(p,1);
    ptgr(p).dsty = gr.posy - fr.pos(p,2);
    
    % absolute distance mesh
    ptgr(p).dst = sqrt(ptgr(p).dstx.^2 + ptgr(p).dsty.^2);
    
    % filter only points that lie in the annulus
    ptgr(p).isin = double(and(ptgr(p).dst > RAD_MIN,ptgr(p).dst < RAD_MAX));
    
    % theta calculation and filtering
    ptgr(p).theta = (ptgr(p).dstx*fr.vel(p,2) - ptgr(p).dsty*fr.vel(p,1))./(ptgr(p).dst.^SCPWR);
    
    % remove NaN caused by points laying on the mesh
    ptgr(p).theta(isnan(ptgr(p).theta)) = 0;
    
    %disp(ptgr(1).theta(p));
    
    pttheta(:,:,p) = ptgr(p).theta.*ptgr(p).isin;
    
end

% averaging through individual points
theta = mean(pttheta,3);

end
