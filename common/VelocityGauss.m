function [vel,vlength] = VelocityGauss(pos,tau,params)
% calculates the gaussian veliocity vector, from the given n-dim position vector
% input:    - pos = position vector
%           - L = length of the position vector
%           - tau = time separation
%           - params = [kernelwidth convowidth2]
% output:   - vel = vector of (horizontal,vertical) velocities
%           - vlength = length of the velocity vector


% minimal position length
if (size(pos,1) < (2*params(2)+1))
    
    vlength = 0;
    vel = NaN*ones(1,size(pos,2));
else
     
    % setting the kernel; code by PH
    % updated by PS, 14-05-2018

    % kernel width, in frames
    w = params(1);

    % discretized kernel
    t = (-params(2):params(2))';
    
    % normalization (MAGIC but works)
    A = sum(t.^2.*exp(-(t/w).^2));

    % definition of the kernel
    vkern = -1/A*t.*exp(-(t/w).^2);

    % memory preallocation
    vel = zeros(size(pos,1)-2*params(2),size(pos,2));
    
    % velocity computation
    for i = 1:size(pos,2)
        vel(:,i) = conv(pos(:,i),vkern,'valid')/tau;
    end
    
    vlength = size(vel,1);
            
end

end
