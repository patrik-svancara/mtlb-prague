function [rpp] = GetSingleFrRPP(npts)
% Randomly places npts particles into the FOV and calculates Voro statistics

FOV = 10.26/1000*[0 1280; 0 800];

% generate positions
rpp.pos = rand(npts,2).*[FOV(1,2) FOV(2,2)] + FOV(:,1)';

% obtain non-dimensional Voronoi areas and remove NaN values
[areas,~,~] = voronoi_areas_mat(rpp.pos, FOV(1,:), FOV(2,:), 20);
rpp.areas = RemoveNaN(areas);

% stats of non-dimensional areas
rpp.mom = Moments(rpp.areas);
rpp.rawpdf = GetPdf(rpp.areas,150,'norm');

% normalization
logareas = log(rpp.areas);
normareas = (logareas - mean(logareas))/std(logareas);

% stats of normalized areas
rpp.normpdf = GetPdf(normareas,150,'norm');

end