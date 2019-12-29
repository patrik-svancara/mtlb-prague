function [ ] = PowerAllGroups()
% Simple loop to obtain input powers for all considered data groups.

% obtain all group labels
groups = dir('../../../results/tracks/mov_*.mat');

% through all the groups
for g = 1:length(groups)
    
    group = strrep(groups(g).name,'.mat','');
    group = strrep(group,'mov_','');
    
    % message to the user
    fprintf('*** Processing group %s ***\n',group);
    
    % process the group
    [~] = PowerSingleGroup(group);
    
end
