function [ ] = EulerMapsAllGroups()
% Simple loop to obtain pseudo Euler maps for all data groups.

NBINS = [32 20];
FOVSIZE = [1280 800]*10.31/1000;

% obtain all group labels
groups = dir('../../../results/tracks/mov_*.mat');

% through all the groups
for g = 1:length(groups)
    
    group = strrep(groups(g).name,'.mat','');
    group = strrep(group,'mov_','');
    
    % message to the user
    fprintf('*** Processing group %s ***\n',group);
    
    % process the group
    [~] = EulerMapsSingleGroup(group,NBINS,FOVSIZE);
    
end

end