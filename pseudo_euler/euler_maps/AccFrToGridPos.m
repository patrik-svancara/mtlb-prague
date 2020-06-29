function [gr] = AccFrToGridPos(gr,pos,acc)
% Adds acceleration from a single frame/track to the position-based grid structure

[frcts,~,~,frXbins,frYbins] = histcounts2(pos(:,1),pos(:,2),gr.Xedges,gr.Yedges);

% add point count
gr.pts = gr.pts + frcts;

% filter points that are within bins
filt = and(frXbins ~= 0,frYbins ~=0);
idx = 1:length(frXbins);

% add data to bins
for s = idx(filt)

    gr.Xacc(frXbins(s),frYbins(s)) = gr.Xacc(frXbins(s),frYbins(s)) + acc(s,1);
    gr.Xacc2(frXbins(s),frYbins(s)) = gr.Xacc2(frXbins(s),frYbins(s)) + acc(s,1).^2;
    
    gr.Yacc(frXbins(s),frYbins(s)) = gr.Yacc(frXbins(s),frYbins(s)) + acc(s,2);
    gr.Yacc2(frXbins(s),frYbins(s)) = gr.Yacc2(frXbins(s),frYbins(s)) + acc(s,2).^2;

    gr.Aacc(frXbins(s),frYbins(s)) = gr.Aacc(frXbins(s),frYbins(s)) + acc(s,3);
    gr.Aacc2(frXbins(s),frYbins(s)) = gr.Aacc2(frXbins(s),frYbins(s)) + acc(s,3).^2;
    
end

end