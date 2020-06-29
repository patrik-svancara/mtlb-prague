function [outgr] = StatsGridVel(gr)
% Returns velocity statistics within grid structure

outgr = struct;

outgr.Xcenters = gr.Xcenters;
outgr.Ycenters = gr.Ycenters;

outgr.Xedges = gr.Xedges;
outgr.Yedges = gr.Yedges;

outgr.mXvel = gr.Xvel./gr.pts;
outgr.stdXvel = sqrt(gr.Xvel2./gr.pts - (gr.Xvel./gr.pts).^2);
outgr.rmsXvel = sqrt(gr.Xvel2./gr.pts);

outgr.mYvel = gr.Yvel./gr.pts;
outgr.stdYvel = sqrt(gr.Yvel2./gr.pts - (gr.Yvel./gr.pts).^2);
outgr.rmsYvel = sqrt(gr.Yvel2./gr.pts);

outgr.mAvel = gr.Avel./gr.pts;
outgr.stdAvel = sqrt(gr.Avel2./gr.pts - (gr.Avel./gr.pts).^2);
outgr.rmsAvel = sqrt(gr.Avel2./gr.pts);

outgr.pts = gr.pts;

end