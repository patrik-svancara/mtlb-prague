function [diffall] = SplineDevSingleMov(mov,tsep)
% Returns spline differences for a movie.

% init of the results field
diffall = [ ];

% through all the tracks
for t = 1:length(mov.tr)
    
    diff = SplineDevSingleTrack(mov.tr(t),tsep);
    
    % diff = NaN means track too short
    if ~isnan(diff)
    
        diffall = cat(1,diffall,diff);
        
    end
    
end

end