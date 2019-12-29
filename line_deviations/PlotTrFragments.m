function [ ] = PlotTrFragments(tr,tau)

for p = 1:size(tr.spltr,1)
    
    indvector = tr.spltr(p,1):tr.spltr(p,2);
    
    time = indvector * tau;
    vertpos = tr.pos(indvector,2);
    
    if tr.spltr(p,4)
        
        plot(time,vertpos,'o','LineWidth',1.3);
        
    else
        
        plot(time,vertpos,'x','LineWidth',1.3);
        
    end
    
    hold on;
    
end

hold off;

end