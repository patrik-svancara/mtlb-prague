function [areas,pts] = VoroSingleMovAlpha(movfr,step,fov,alpha,norm)
% Returns Voronoi areas for a single movie and the count of points per each frame.
% Within the movie, only frames separated by step are considered.
% Recalculates Voronoi areas with dilution specified by alpha.

if nargin == 4
    
    norm = false;
    
end

% memory prealloc (overkill even if frames are not diluted)
allareas = zeros(sum([movfr.fr(1:step:end).pts]),1);
allarind = 1;

pts = zeros(length(1:step:length(movfr.fr)),1);
ptsind = 1;

for f = 1:step:length(movfr.fr)
    
    % obtain single-frame dimensional Voronoi areas
    [thisareas,pts(ptsind)] = VoroSingleFr(movfr.fr(f),fov,alpha,false);
    
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

% trim empy array fields
areas = allareas(1:sum(pts));

% normalization, if required
if norm
    
    areas = areas./mean(areas);
    
end

end