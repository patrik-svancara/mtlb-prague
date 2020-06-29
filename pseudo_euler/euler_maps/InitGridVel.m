function [gr] = InitGridVel(xbins,ybins)
% Init velocity grid (position-based)

gr = struct;

gr.Xedges = xbins;
gr.Xcenters = (xbins(2:end) + xbins(1:end-1))/2;

gr.Yedges = ybins;
gr.Ycenters = (ybins(2:end) + ybins(1:end-1))/2;

% prealloc gr structure
EMPTY = zeros(length(gr.Xcenters),length(gr.Ycenters));

    % Cartesian components of velocity
    gr.Xvel = EMPTY;
    gr.Xvel2 = EMPTY;

    gr.Yvel = EMPTY;
    gr.Yvel2 = EMPTY;

    % Absolute velocity
    gr.Avel = EMPTY;
    gr.Avel2 = EMPTY;

    % Bin counts
    gr.pts = EMPTY;
    
end