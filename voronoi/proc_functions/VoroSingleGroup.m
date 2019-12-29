function [voro] = VoroSingleGroup(group,movtype,step)
% Returns voro struct of the normalized Voronoi areas for the given data group.
% Does not perform statistical analysis.
% Assumes that Voronoi areas are already computed.

% deps
addpath('../common/');

% field of view
FOV = (10.26/1000).*[0 1280; 0 800];

% normalize manually, to obtain Moments
NORMALIZE = false;

% load data
MOVFRTEMPLATE = '../../data/tracks/%s/movfr%s_%s.mat';
load(sprintf(MOVFRTEMPLATE,group,movtype,group));

% memory prealloc 
voroitem = struct('areas',[],'pts',[],'mom',[],'step',[],'alpha',[]);
voro(1:length(movfr)) = voroitem;

% for each movie
for m = 1:length(movfr)
    
    % message to the user
    fprintf('Processing run %d/%d\n',m,length(movfr));
    
    voro(m).step = step;
    voro(m).alpha = 1; % as we do not dilute particles in the precomputed data
    
    [voro(m).areas,voro(m).pts] = VoroSingleMov(movfr(m),step,NORMALIZE);
    
    voro(m).mom = Moments(voro(m).areas);
    
    % normalize Voro areas
    voro(m).areas = voro(m).areas/voro(m).mom(2);
    
end

end