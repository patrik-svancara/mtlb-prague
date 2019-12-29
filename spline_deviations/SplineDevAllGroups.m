function [ ] = SplineDevAllGroups(tsepvec)
% Simple loop to obtain spline-fit deviations for all data groups.

groups = dir('../../data/tracks/group*.txt');

% through all the groups
for g = 1:length(groups)
    
    group = strrep(groups(g).name,'.txt','');
    
    % message to the user
    fprintf('*** Processing %s ***\n',group);
    
    % process the group
    [~] = SplineDevSingleGroup(group,tsepvec);
    
end

end