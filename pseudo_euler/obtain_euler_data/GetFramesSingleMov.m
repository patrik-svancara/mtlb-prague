function [movfr] = GetFramesSingleMov(mov)
% Returns mov struct with data arranged in frames.
% Single mov struct as input.

% figure out the number of points in each frame
pts = zeros(mov.caminfo.nframes,1);

% histogram of points per frame for memory prealloc
for i = 1:length(mov.tr)
    
    for j = 1:length(mov.tr(i).fr)
        
        pts(int16(mov.tr(i).fr(j))) = pts(int16(mov.tr(i).fr(j))) + 1;
        
    end
end

% copy auxiliary data into the out variable
movfr.name = mov.name;
movfr.scfactor = mov.scfactor;
movfr.caminfo = mov.caminfo;
movfr.gaussparams = mov.gaussparams;

% define new struct
movfr.fr = struct;

% for all the frames
for i = 1:movfr.caminfo.nframes
    
    % preallocate memory
    movfr.fr(i).pos = zeros(pts(i),2);
    movfr.fr(i).vel = zeros(pts(i),3);
    movfr.fr(i).acc = zeros(pts(i),3);
    
    movfr.fr(i).pts = pts(i);
    movfr.fr(i).time = i/movfr.caminfo.fps;
    
    movfr.fr(i).tr = zeros(pts(i),1);
    
end

% temporary frame index, to keep track about how many points are recorded
% in each frame
frcount = ones(mov.caminfo.nframes,1);

for i = 1:length(mov.tr)
    
    for j = 1:mov.tr(i).length
        
        % get frame index
        frind = int16(mov.tr(i).fr(j));
        
        % save respective fields
        movfr.fr(frind).pos(frcount(frind),:) = mov.tr(i).pos(j,:);
        movfr.fr(frind).vel(frcount(frind),:) = mov.tr(i).vel(j,:);
        movfr.fr(frind).acc(frcount(frind),:) = mov.tr(i).acc(j,:);
        movfr.fr(frind).tr(frcount(frind)) = i;
        
        % update current index inside frame
        frcount(frind) = frcount(frind) + 1;
        
    end
    
end

end
