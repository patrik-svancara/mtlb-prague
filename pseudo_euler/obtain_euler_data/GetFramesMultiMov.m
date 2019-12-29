function [mov2] = GetFramesMultiMov(MovNameIN)
% Recursive use of GetFramesSingleMov on 1-D array of mov structures.

% variable is called mov
load([MovNameIN '.mat']);

figure;

for i = 1:length(mov)
    
    % message to the user
    fprintf('Processing movie %d/%d.\n',i,length(mov));
    
    mov2(i) = GetFramesSingleMov(mov(i));
    
    plot([mov2(i).fr(:).pts],'-');
    title(sprintf('Movie %d/%d',i,length(mov)));
    
    pause(1);
    
end

save([MovNameIN 'fr.mat'],'mov2');

end