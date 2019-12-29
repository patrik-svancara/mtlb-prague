function [areas,pts] = VoroSingleFr(fr,fov,alpha,norm)
% Returns Voronoi areas for a single fr structure and their count.
% If the area is not defined, returns NaN.
% alpha is  [0..1[ = relative dilution of the given fraction
%           1 = does nothing with the frame
%           ]1..inf[ = absolute dilution towards the given int of points

if nargin == 3
    norm = false;
end

if and(alpha > 0,alpha < 1)
    
    % relative dilution
    fr = DiluteFrPtsRel(fr,alpha);
    
elseif alpha > 1
    
    % absolute dilution
    fr = DiluteFrPtsAbs(fr,alpha);
    
end

% treshold for minimal number of particles
MINPTS = 20;

% Get Voronoi, already normalized
[areas,avgarea,pts] = voronoi_areas_mat(fr.pos, fov(1,:), fov(2,:), MINPTS);

if ~norm

    % return to dimensional Voronoi areas
    areas = areas.*avgarea;
    
end

end