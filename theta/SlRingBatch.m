load('../../results/metadata.mat');

%KAPPA = 9.97e-8;

for m = 15
    
    fprintf('*** Group %s ***\n',meta(m).group);
    
%    load("../../results/theta_res/sl"+meta(m).mseqfile);
    
    %load("../../ondrej/"+meta(m).grid);
    load('../../results/mygrid.mat');
    
    ring.p = FindRingPosition(gr,slmseqtheta,meta(m).trh);
    ring.n = FindRingPosition(gr,slmseqtheta,-meta(m).trh);
    
    a = abs(ring.p.posx - ring.n.posx);
    b = abs(ring.p.posy - ring.n.posy);
    ring.diam = [a b sqrt(a.^2 + b.^2)];
    
    ring.a = RingVortAverage(ring);
    
    ring.time = ((1:size(slmseqtheta,1))-1)*1e3/meta(m).fps;
    
    ring.trh = meta(m).trh;
    
%     ring.p.circ = ring.p.wt.*PIXAREA;
%     ring.n.circ = ring.n.wt.*PIXAREA;
%     
%     ring.p.qscale = sqrt(ring.p.size.*KAPPA./ring.p.circ);
%     ring.n.qscale = sqrt(-ring.n.size.*KAPPA./ring.n.circ);
%     
%     ring.a.qscale = mean([ring.p.qscale ring.n.qscale],2);
%     
%     save("../../results/theta_res/ring/sl"+meta(m).ringfile,'ring');
%     
%     rg(m) = ring;
%     
end
    