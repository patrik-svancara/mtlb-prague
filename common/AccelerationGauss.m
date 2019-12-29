function [acc,alength] = AccelerationGauss(pos,tau,params)
% calculates the gaussian acceleration vector, from the given n-dim position vector
% input:    - pos = position vector
%           - L = length of the position vector
%           - tau = time separation
%           - params = [kernelwidth convowidth2]
% output:   - acc = vector of accelerations
%           - alength = length of the velocity vector


% minimal position length
if (size(pos,1) < (2*params(2)+1))
    
    alength = 0;
    acc = NaN*ones(1,size(pos,2));
else
     
    % setting the kernel
    % code by PS 15-06-2018, from original French code

    % kernel width, in frames
    w = params(1);

    % discretized kernel
    t = (-params(2):params(2))';
    
    % normalization coefficients (MAGIC but works)
    ker = (2*(t/w).^2 -1).*exp(-(t/w).^2);
    tlen = length(t);
    
    % definition of the kernel
    akern = 2*(sum(ker) - tlen*ker)/(sum(t.^2)*sum(ker) - tlen*sum(ker.*(t.^2)));
    %akern = 2*(0 + tlen*ker)/(sum(t.^2)*sum(ker) - tlen*sum(ker.*(t.^2)));
    
    % memory preallocation
    acc = zeros(size(pos,1)-2*params(2),size(pos,2));
    
    % acceleration computation
    for i = 1:size(pos,2)
        acc(:,i) = conv(pos(:,i),akern,'valid')/tau;
    end
    
    alength = size(acc,1);
            
end

end
