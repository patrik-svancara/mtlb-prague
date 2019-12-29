function [scvel,scvlength,scacc,scalength] = ScKinematicsSingleTr(tr,step,tau,params)
% Calculates velocities and accelerations for the given time-scale tsep.
% Employs Gaussian convolution protocol
% Outputs new items tr.scvel, tr.scvlen, tr.scinc, tr.scilen
% step = probed scale in frames
% tau = equivalent time separation

% divide tracks into subtrajectories
subtr = Divide(tr.pos,step);

 % check whether some data remained
if (sum([subtr(:).length]) ~= 0)
    
    % for all subtracks
    for j = 1:length(subtr)
        
        % velocity
        [subtr(j).vel,subtr(j).vlength] = VelocityGauss(subtr(j).pos,tau,params);
        
        % velocity magnitude
        subtr(j) = VelocityAbsolute(subtr(j));
        
        % acceleration
        [subtr(j).acc,subtr(j).alength] = AccelerationGauss(subtr(j).pos,tau,params);
        
        % acceleration magnitude and long / trans projections
        subtr(j) = AccelerationAbsolute(subtr(j));
        subtr(j) = AccelerationProjection(subtr(j));
        
    end
    
    % join the data
    [scvel,scvlength,scacc,scalength] = Join(subtr,step);
    
    
else
    
    scvel = NaN*ones(1,3);
    scvlength = 0;
    scacc = NaN*ones(1,5);
    scalength = 0;
    
end

end