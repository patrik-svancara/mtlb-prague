function [allareas,pts] = VoroSingleMov(movfr,step,norm)
% Returns Voronoi areas for a single movie and the count of points per each frame.
% Within the movie, only frames separated by step param are considered.
% Assumes Voronoi areas are already stored in fr struct.

if nargin == 2
    
    norm = false;
    
end

% memory prealloc (should be exactly of the right size)
allareas = zeros(sum([movfr.fr(1:step:end).areapts]),1);
allarind = 1;

pts = zeros(length(1:step:length(movfr.fr)),1);
ptsind = 1;

for f = 1:step:length(movfr.fr)
    
    % local data
    thisareas = movfr.fr(f).areas;
    pts(ptsind) = movfr.fr(f).areapts;
    
    if pts(ptsind) ~= 0
    
        % local indices
        thisarind = allarind + (0:pts(ptsind)-1);
    
        % add data to the vector
        allareas(thisarind) = RemoveNaN(thisareas);
    
        % update global index
        allarind = allarind + pts(ptsind);
        
    end
    
    % update pts index
    ptsind = ptsind + 1;
    
end

% normalization, if required
if norm
    
    allareas = allareas./mean(allareas);
    
end

end