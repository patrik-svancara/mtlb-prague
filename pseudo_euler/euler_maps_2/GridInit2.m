function [gr] = GridInit2(edg_vx,edg_vy)
% init grid in vel-vel phase space
% edg_vx | edg_vy: edges of the grid

gr = struct;

gr.Xedges = edg_vx;
gr.Xcenters = (edg_vx(2:end) + edg_vx(1:end-1))/2;

gr.Yedges = edg_vy;
gr.Ycenters = (edg_vy(2:end) + edg_vy(1:end-1))/2;

% acceleration components prealloc
EMPTY = zeros(length(gr.Xcenters),length(gr.Ycenters));

    % cartesian components of acceleration
    gr.Xacc = EMPTY;
    gr.Xacc2 = EMPTY;

    gr.Yacc = EMPTY;
    gr.Yacc2 = EMPTY;

    % absolute acceleration
    gr.Aacc = EMPTY;
    gr.Aacc2 = EMPTY;

    % count of points per bin
    gr.pts = EMPTY;
    
end