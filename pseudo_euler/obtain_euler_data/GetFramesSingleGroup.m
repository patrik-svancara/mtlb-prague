function [movf] = GetFramesSingleGroup(group,mov)
% Returns 1-D mov struct array with data arranged in frames.
% 1-D mov struct array within a group as input.

% load data if they are not given
if nargin < 2
    MOVTEMPLATE = '../../../results/tracks/mov_%s.mat';
    load(sprintf(MOVTEMPLATE,group));
end

% save data template
MOVFRTEMPLATE = '../../../results/tracks/movfr_%s.mat';

% loop-process movies one by one
for m = 1:length(mov)
    
    % message to the user
    fprintf('Processing run %d/%d\n',m,length(mov));
    
    movf(m) = GetFramesSingleMov(mov(m));
    
    % plot for the user
    plot([movf(m).fr(:).pts],'-');
    xlabel('Frame number');
    ylabel('Particles per frame');
    title(sprintf('Run %d/%d',m,length(mov)));
    
    pause(0.5);
    
end

% message to the user
disp('Saving MATLAB file...');

% save the new structure
save(sprintf(MOVFRTEMPLATE,group),'movf');

% message to the user
disp('Done.');

end
