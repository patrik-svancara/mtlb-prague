function [gr] = GridInit3(edgx,edgy)
% init grid in real space
% edgx | edgy: edges of the grid

gr = struct;

gr.Xedges = edgx;
gr.Xcenters = (edgx(2:end) + edgx(1:end-1))/2;

gr.Yedges = edgy;
gr.Ycenters = (edgy(2:end) + edgy(1:end-1))/2;

% components prealloc
EMPTY = zeros(length(gr.Xcenters),length(gr.Ycenters));

    % cartesian components of velocity
    gr.Xvel = EMPTY;
    gr.Yvel = EMPTY;
    gr.Avel = EMPTY;

    % cartesian components of acceleration
    gr.Xacc = EMPTY;
    gr.Yacc = EMPTY;
    gr.Aacc = EMPTY;

    
    % count of points per bin
    gr.pts = EMPTY;
    
end