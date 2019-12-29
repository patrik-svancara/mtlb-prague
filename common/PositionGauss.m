function [spos,slength] = PositionGauss(pos,params)
% Gaussian smoothing of 2-dim position vector
% input:    - tr = single traj structure
%           - params = [kernelwidth convowidth2]
% output:   - spos = smoothened positions
%           - slength = length of position vector


% minimal position length
if (size(pos,1) < (2*params(2)+1))
    
    slength = 0;
    spos = NaN*ones(1,size(pos,2));
else
     
    % setting the kernel
    % code by MG 19-06-2018

    % kernel width, in frames
    w = params(1);

    % discretized kernel
    t = (-params(2):params(2))';
    
    % normalization
    A = 1/sum(exp(-(t/w).^2));
    
    % definition of the kernel
    pkern = A*exp(-(t/w).^2);
    
    % memory preallocation
    spos = zeros(size(pos,1)-2*params(2),size(pos,2));
    
    % smoothened position computation
    for i = 1:size(pos,2)
        spos(:,i) = conv(pos(:,i),pkern,'valid');
    end
    
    slength = size(spos,1);
            
end

end