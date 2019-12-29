function [ ] = DirChangeAllGroups(tsepvec)
% Simple loop to obtain direction angle distributions for all data groups.

groups = dir('../../data/tracks/group*.txt');

% histogram bin edges
HEDGES = linspace(0,1,101);

% through all the groups
for g = 1:length(groups)
    
    group = strrep(groups(g).name,'.txt','');
    
    % message to the user
    fprintf('*** Processing %s ***\n',group);
    
    % process the group
    [~] = DirChangeSingleGroup(group,HEDGES,tsepvec);
    
end

end