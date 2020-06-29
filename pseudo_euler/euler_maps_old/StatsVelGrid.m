function [gr] = StatsVelGrid(gr)

gr.mXacc = gr.Xacc./gr.pts;
gr.stdXacc = sqrt(gr.Xacc2./gr.pts - (gr.Xacc./gr.pts).^2);
gr.rmsXacc = sqrt(gr.Xacc2./gr.pts);

gr.mYacc = gr.Yacc./gr.pts;
gr.stdYacc = sqrt(gr.Yacc2./gr.pts - (gr.Yacc./gr.pts).^2);
gr.rmsYacc = sqrt(gr.Yacc2./gr.pts);

gr.mAacc = gr.Aacc./gr.pts;
gr.stdAacc = sqrt(gr.Aacc2./gr.pts - (gr.Aacc./gr.pts).^2);
gr.rmsAacc = sqrt(gr.Aacc2./gr.pts);

end
