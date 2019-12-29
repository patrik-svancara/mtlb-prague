function [mcorrmov,wcorrmov] = VelCorrelationSingleMov(mov,tsep,gr)
% Mean velocity fluctuation autocorrelation coefficient for a movie.

% dependencies
addpath('../common/');
addpath('../pseudo_euler/euler_maps/');

% prepare interpolation grid - NOT USED
% mgr = struct;
% [mgr.X,mgr.Y,mgr.VX,mgr.VY] = GrToMesh(gr);

% memory preallocation
mcorrs = zeros(length(mov.tr),2);
wcorrs = zeros(length(mov.tr),1);

for i = 1:length(mov.tr)
    
    [mcorrs(i,:),wcorrs(i)] = VelCorrelationSingleTr(mov.tr(i),tsep,gr);
    
end

% remove empty cases
mcorrs = RemoveNaN(mcorrs);
wcorrs = RemoveNaN(wcorrs);

% calculate (weighted) mean value and corresponding weight
mcorrmov = sum(mcorrs.*wcorrs)./sum(wcorrs);
wcorrmov = sum(wcorrs);

end