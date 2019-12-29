function [pwinc,lenpwinc] = PowerIncSingleTr(tr,tsep)
% Calculates mean power increment for a single trajectory, for the given
% time separation, according to [Bhatnagar, Phys. Rev. E (2018)]
% Does NOT remove any mean flow.

% return NaN for too short trajectories
if tr.vlength <= tsep
    
    pwinc = NaN;
    lenpwinc = 0;
    
    return
end

% memory preallocation
pwinc = zeros(tr.vlength - tsep,1);

% power increments = differences of kinetic energy density
for i = 1:(tr.vlength - tsep)
    
    pwinc(i,:) = (norm(tr.vel(i+tsep,1:2))^2 - norm(tr.vel(i,1:2))^2)/2;
    
end

% length of the returned vector
lenpwinc = size(pwinc,1);

end