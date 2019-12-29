function [outgr] = GridStats3(gr)

outgr = struct;

outgr.Xcenters = gr.Xcenters;
outgr.Ycenters = gr.Ycenters;

outgr.Xedges = gr.Xedges;
outgr.Yedges = gr.Yedges;

outgr.Xvel = gr.Xvel./gr.pts;
outgr.Yvel = gr.Yvel./gr.pts;
outgr.Avel = gr.Avel./gr.pts;

outgr.Xacc = gr.Xacc./gr.pts;
outgr.Yacc = gr.Yacc./gr.pts;
outgr.Aacc = gr.Aacc./gr.pts;

outgr.pts = gr.pts;

end
