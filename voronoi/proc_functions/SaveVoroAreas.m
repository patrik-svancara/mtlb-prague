function [movfr] = SaveVoroAreas(group)
% Computes Voronoi areas for each frame and saves them into a dedicated mat
% file.

% load data
MOVFRTEMPLATE = '../../data/tracks/%s/movfr%s_%s.mat';
load(sprintf(MOVFRTEMPLATE,group,'',group));

FOV = 10.26/1000*[0 1280; 0 800];

for m = 1:length(movfr)
    
    fprintf('Processing run %d/%d\n',m,length(movfr));
    
    for f = 1:length(movfr(m).fr)
        
        [movfr(m).fr(f).areas,movfr(m).fr(f).areapts] = VoroSingleFr(movfr(m).fr(f),FOV,1,false);
        
    end
    
end

save(sprintf(MOVFRTEMPLATE,group,'voro',group),'movfr');

end