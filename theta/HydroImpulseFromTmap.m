function [ring] = HydroImpulseFromTmap(GR,ring)
% Returns the estimate of hydrodynamic impulse from vortex rings.
% imp is defined as imp = \int (r \times \omega) dV
% r is computed with respect to the origin
% \omega is estimated simply as T

for t = 1:length(ring.time)
    
    if ~isnan(ring.a.posy(t))
        
        % distance from origin
        dst = sqrt((GR.posx - ring.a.posx(t)).^2 + (GR.posy - ring.a.posy(t)).^2);
        
        % vorticity is estimated from T-map
        thmap.p = reshape(ring.p.data(t,:,:),size(GR.posx,1),size(GR.posx,2));
        thmap.n = reshape(ring.n.data(t,:,:),size(GR.posx,1),size(GR.posx,2));

        % \omega is perpendicular to r => \times is a simple multiplication
        % integral is replaced with summation
        ring.p.imp(t) = sum(sum((thmap.p).*dst));
        ring.n.imp(t) = sum(sum((thmap.n).*dst));
        
    else
        
        ring.p.imp(t) = NaN;
        ring.n.imp(t) = NaN;
        
    end

end

end