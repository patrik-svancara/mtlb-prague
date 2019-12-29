function [rppst,expst] = VoroStatsAllGroups()
% Returns stats of RPP simulations and exp data for all considered data
% groups. Constants can be changed inside the function.

STEP = 4;
BINS = linspace(-8,4,101);

groups = dir('../../data/tracks/group*.txt');

% through all the groups
for g = 1:length(groups)
    
    group = strrep(groups(g).name,'.txt','');
    
    % message to the user
    fprintf('*** Processing %s ***\n',group);
    
    % experiment
    voro = VoroSingleGroup(group,'voro',STEP);
    expst(g) = VoroStatsSingleGroup(voro,BINS);
    
    % RPP
    voro = VoroSingleGroup(group,'randvoro',STEP);
    rppst(g) = VoroStatsSingleGroup(voro,BINS);
    
end

end