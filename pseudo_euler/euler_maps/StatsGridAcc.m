function [outgr] = StatsGridAcc(gr)
% Returns acceleration statistics within grid structure

outgr = struct;

outgr.Xcenters = gr.Xcenters;
outgr.Ycenters = gr.Ycenters;

outgr.Xedges = gr.Xedges;
outgr.Yedges = gr.Yedges;

outgr.mXacc = gr.Xacc./gr.pts;
outgr.stdXacc = sqrt(gr.Xacc2./gr.pts - (gr.Xacc./gr.pts).^2);
outgr.rmsXacc = sqrt(gr.Xacc2./gr.pts);

outgr.mYacc = gr.Yacc./gr.pts;
outgr.stdYacc = sqrt(gr.Yacc2./gr.pts - (gr.Yacc./gr.pts).^2);
outgr.rmsYacc = sqrt(gr.Yacc2./gr.pts);

outgr.mAacc = gr.Aacc./gr.pts;
outgr.stdAacc = sqrt(gr.Aacc2./gr.pts - (gr.Aacc./gr.pts).^2);
outgr.rmsAacc = sqrt(gr.Aacc2./gr.pts);

outgr.pts = gr.pts;

end