function [ ] = VelMapAllGroups()
% Simple loop to obtain Lagrangian velocity statistics of all data groups.

% obtain all group labels
groups = dir('../../../results/tracks/mov_*.mat');

% through all the groups
for g = 1:length(groups)
    
    group = strrep(groups(g).name,'.mat','');
    group = strrep(group,'mov_','');
    
    % message to the user
    fprintf('*** Processing group %s ***\n',group);
    
    % process the group
    [~] = VelMapSingleGroup(group);
    
end

end