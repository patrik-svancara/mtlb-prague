function [outgr] = GridStats3(gr)
% Returns velocity statistics within grid structure

outgr = struct;

outgr.Xcenters = gr.Xcenters;
outgr.Ycenters = gr.Ycenters;

outgr.Xedges = gr.Xedges;
outgr.Yedges = gr.Yedges;

outgr.mXvel = gr.Xvel./gr.pts;
outgr.mYvel = gr.Yvel./gr.pts;
outgr.mAvel = gr.Avel./gr.pts;

outgr.pts = gr.pts;

end
