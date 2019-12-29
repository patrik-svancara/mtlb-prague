function [theta] = ThetaFromFrame(fr,gr,MAX_RADIUS)

if fr.pts == 0
    
    theta = zeros(size(gr.posx));
    return
    
end

pttheta = zeros([size(gr.posx) fr.pts]);

for p = 1:fr.pts
    
    ptgr(p).dstx = gr.posx - fr.pos(p,1);
    ptgr(p).dsty = gr.posy - fr.pos(p,2);
    
    ptgr(p).dst = sqrt(ptgr(p).dstx.^2 + ptgr(p).dsty.^2);
    
    ptgr(p).isin = double(ptgr(p).dst < MAX_RADIUS);
    
    ptgr(p).theta = (ptgr(p).dstx*fr.vel(p,2) - ptgr(p).dsty*fr.vel(p,1))./(ptgr(p).dst.^2);
    pttheta(:,:,p) = ptgr(p).theta.*ptgr(p).isin;
    
end

theta = mean(pttheta,3);