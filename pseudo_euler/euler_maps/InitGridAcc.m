function [gr] = InitGridAcc(xbins,ybins)
% Init acceleration grid (position or velocity-based)

gr = struct;

gr.Xedges = xbins;
gr.Xcenters = (xbins(2:end) + xbins(1:end-1))/2;

gr.Yedges = ybins;
gr.Ycenters = (ybins(2:end) + ybins(1:end-1))/2;

% prealloc gr structure
EMPTY = zeros(length(gr.Xcenters),length(gr.Ycenters));

    % Cartesian components of acceleration
    gr.Xacc = EMPTY;
    gr.Xacc2 = EMPTY;

    gr.Yacc = EMPTY;
    gr.Yacc2 = EMPTY;

    % Absolute acceleration
    gr.Aacc = EMPTY;
    gr.Aacc2 = EMPTY;

    % Bin counts
    gr.pts = EMPTY;
    
end