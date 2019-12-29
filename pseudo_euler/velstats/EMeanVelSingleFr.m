function [mvel,mvel2,pts] = EMeanVelSingleFr(fr)
% Single frame velocity stats

if fr.pts == 0
    
    mvel = zeros(1,size(fr.vel,2));
    mvel2 = mvel;
    pts = 0;
    
    return
    
end

mvel = mean(fr.vel,1);
mvel2 = mean(fr.vel.^2,1);
pts = fr.pts;

end