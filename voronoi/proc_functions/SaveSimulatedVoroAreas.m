function [movfr] = SaveSimulatedVoroAreas(group)
% Computes Voronoi areas for each frame and saves them into a dedicated mat
% file.

% load data
MOVFRTEMPLATE = '../../data/tracks/%s/movfr%s_%s.mat';
load(sprintf(MOVFRTEMPLATE,group,'',group));

% destroy irrelevant fields
for m = 1:length(movfr)
    movfr(m).fr = rmfield(movfr(m).fr,'vel');
    movfr(m).fr = rmfield(movfr(m).fr,'tr');
end

FOV = 10.26/1000*[0 1280; 0 800];

for m = 1:length(movfr)
    
    fprintf('Processing run %d/%d\n',m,length(movfr));
    
    for f = 1:length(movfr(m).fr)
        
        if movfr(m).fr(f).pts ~= 0
        
            [movfr(m).fr(f).pos,movfr(m).fr(f).pts] = RPPsimulatorSingleFr(movfr(m).fr(f),FOV);
        
        end
        
        [movfr(m).fr(f).areas,movfr(m).fr(f).areapts] = VoroSingleFr(movfr(m).fr(f),FOV,1,false);
        
    end
    
end

save(sprintf(MOVFRTEMPLATE,group,'randvoro',group),'movfr');

end