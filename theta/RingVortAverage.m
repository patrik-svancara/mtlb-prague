function [avrg] = RingVortAverage(rg)
% Calculates the weighted average of the positive and negative vortices.

avrg.wt = rg.p.wt - rg.n.wt;

avrg.posx = (rg.p.posx.*rg.p.wt - rg.n.posx.*rg.n.wt)./avrg.wt;
avrg.posy = (rg.p.posy.*rg.p.wt - rg.n.posy.*rg.n.wt)./avrg.wt;

avrg.size = rg.p.size + rg.n.size;

end

