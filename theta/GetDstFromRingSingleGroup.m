function [mov] = GetDstFromRingSingleGroup(meta,ring,frrange)
% calculcates the distance between points and ring positions obtained at
% the same time

% load mov struct
MOVTEMPLATE = '../../results/tracks/mov_%s.mat';
load(sprintf(MOVTEMPLATE,meta.group),'mov');

% load movf struct
MOVFRTEMPLATE = '../../results/tracks/movfr_%s.mat';
load(sprintf(MOVFRTEMPLATE,meta.group),'movf');

% for all movies and frames
for m = 1:length(movf)

    for f = 1:length(movf(m).fr)

        % check if both vortex positions are available and we are within
        % the correct frame range
        if and(~isnan(ring.diam(f,3)),and(f >= frrange(1),f <= frrange(2)))

            % calculate distances from both vortices and from ring centre
            movf(m).fr(f).dst(:,1) = ...
                sqrt((movf(m).fr(f).pos(:,1) - ring.p.posx(f)).^2 + ...
                     (movf(m).fr(f).pos(:,2) - ring.p.posy(f)).^2);


            movf(m).fr(f).dst(:,2) = ...
                sqrt((movf(m).fr(f).pos(:,1) - ring.n.posx(f)).^2 + ...
                     (movf(m).fr(f).pos(:,2) - ring.n.posy(f)).^2);
                 
                 
            movf(m).fr(f).dst(:,3) = ...
                sqrt((movf(m).fr(f).pos(:,1) - ring.a.posx(f)).^2 + ...
                     (movf(m).fr(f).pos(:,2) - ring.a.posy(f)).^2);

            
        else
            
            % no ring is detected on the given frame
            movf(m).fr(f).dst = NaN*ones(movf(m).fr(f).pts,3);

        end
        
    end


    % reconstruct dst to the mov structure
    for t = 1:length(mov(m).tr)

        for i = 1:mov(m).tr(t).length

            fi = (movf(m).fr(mov(m).tr(t).fr(i)).tr == t);
            mov(m).tr(t).dst(i,:) = movf(m).fr(mov(m).tr(t).fr(i)).dst(fi,:);

        end
    end

end

% save the movie
save(sprintf('../../results/tracks/mov_%s.mat',meta.group),'mov');

end