function [ ] = SaveVoroAreasAllGroups(simulate)
% Simple loop to calculate Voronoi areas for all data sets.

groups = dir('../../data/tracks/group*.txt');

% through all the groups
for g = 1:length(groups)
    
    group = strrep(groups(g).name,'.txt','');
    
    % message to the user
    fprintf('*** Processing %s ***\n',group);
    
    if simulate
        % save simulated RPP
        [~] = SaveSimulatedVoroAreas(group);
    
    else
        % save measured positions
        [~] = SaveVoroAreas(group);
    
    end
    
end

end