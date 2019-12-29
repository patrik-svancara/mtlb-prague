function [mov2,frcount] = GetFramesSingleMov(mov)
% Returns mov structure with data arranged in frames. Single mov struct as
% input.

% figure out the number of points in each frame
pts = zeros(mov.caminfo.nframes,1);

% histogram of points
for i = 1:length(mov.tr)
    
    for j = 1:length(mov.tr(i).fr)
        
        pts(int16(mov.tr(i).fr(j))) = pts(int16(mov.tr(i).fr(j))) + 1;
        
    end
end

% copy auxiliary data into the out variable
mov2.name = mov.name;
mov2.scfactor = mov.scfactor;
mov2.caminfo = mov.caminfo;
mov2.velparams = mov.velparams;

% define new struct
mov2.fr = struct;

for i = 1:mov2.caminfo.nframes
    
    % preallocate memory
    mov2.fr(i).pos = zeros(pts(i),2);
    mov2.fr(i).vel = zeros(pts(i),2);
    
    mov2.fr(i).pts = pts(i);
    mov2.fr(i).time = i/mov2.caminfo.fps;
    
    mov2.fr(i).tr = zeros(pts(i),1);
    
end

% temporary frame index, to keep track about how many points are recorded
% in each frame
frcount = ones(mov.caminfo.nframes,1);

for i = 1:length(mov.tr)
    
    for j = 1:mov.tr(i).length
        
        % get frame index
        frind = int16(mov.tr(i).fr(j));
        
        % save respective fields
        mov2.fr(frind).pos(frcount(frind),:) = mov.tr(i).pos(j,:);
        mov2.fr(frind).vel(frcount(frind),:) = mov.tr(i).vel(j,:);
        mov2.fr(frind).tr(frcount(frind)) = i;
        
        % update current index inside frame
        frcount(frind) = frcount(frind) + 1;
        
    end
    
end

end
        