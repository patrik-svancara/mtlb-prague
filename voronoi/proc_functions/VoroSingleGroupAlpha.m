function [voro] = VoroSingleGroupAlpha(group,step,alpha)
% Returns voro struct of the normalized Voronoi areas for the given data group.
% Does not perform statistical analysis.

% deps
addpath('../common/');

% field of view
FOV = (10.26/1000).*[0 1280; 0 800];

% normalize manually, to obtain Moments
NORMALIZE = false;

% load data
MOVFRTEMPLATE = '../../data/tracks/%s/movfr_%s.mat';
load(sprintf(MOVFRTEMPLATE,group,group));

% memory prealloc 
voroitem = struct('areas',[],'pts',[],'mom',[],'step',[],'alpha',[]);
voro(1:length(movfr)) = voroitem;

% for each movie
for m = 1:length(movfr)
    
    % message to the user
    fprintf('Processing run %d/%d\n',m,length(movfr));
    
    voro(m).step = step;
    voro(m).alpha = alpha;
    
    [voro(m).areas,voro(m).pts] = VoroSingleMovAlpha(movfr(m),step,FOV,alpha,NORMALIZE);
    
    voro(m).mom = Moments(voro(m).areas);
    
    % normalize Voro areas
    voro(m).areas = voro(m).areas/voro(m).mom(2);
    
end

end