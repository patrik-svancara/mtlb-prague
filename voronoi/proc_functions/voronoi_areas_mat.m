function [areas,mareas,npts] = voronoi_areas_mat (xy, xlim, ylim, min_npart)

npts = size(xy,1);
areas = NaN(npts, 1);
mareas = 0;
if (npts < min_npart)
    npts = 0;
    areas = NaN;
    return
end

if (npts > 2 && npts > min_npart)
    %% voronoi
    [v,c] = voronoin(xy);
    
    %% limination des points hors cadre et des cellules correspondantes
    idx = find (v(:,1) < xlim(1) | v(:,1) > xlim(2) | v(:,2) < ylim(1) | v(:,2) > ylim(2));
    tst = cellfun (@(vec) ~isempty(intersect (vec, idx)), c);
    c(tst)=[];
    
    %% nombre reel de particules prises en compte
    npts = numel (c);
    
    if (npts >= min_npart)
        %% calcul des aires
        areas(~tst) = cellfun (@(idx) polyarea (v(idx,1), v(idx,2)),c);
    else
        %warning ('voronoi_analysis: not enough particles');
        npts = 0;
    end
    mareas = mean (areas(~ isnan (areas)));
    areas = areas./mareas;
else
    
    %warning ('voronoi_areas: not enough particles')
    npts = 0;
end
end
