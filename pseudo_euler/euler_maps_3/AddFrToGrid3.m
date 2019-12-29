function [gr] = AddFrToGrid3(gr,fr)
% adds single frame to the grid structure

% use histcounts2 to add data
[frcts,~,~,frXbins,frYbins] = histcounts2(fr.pos(:,1),fr.pos(:,2),gr.Xedges,gr.Yedges);

% add point count
gr.pts = gr.pts + frcts;

% filter points that are within bins
filt = and(frXbins ~= 0,frYbins ~=0);
idx = 1:length(frXbins);

for s = idx(filt)

    % add data to bins
    gr.Xvel(frXbins(s),frYbins(s)) = gr.Xvel(frXbins(s),frYbins(s)) + fr.vel(s,1);
    gr.Yvel(frXbins(s),frYbins(s)) = gr.Yvel(frXbins(s),frYbins(s)) + fr.vel(s,2);
    gr.Avel(frXbins(s),frYbins(s)) = gr.Avel(frXbins(s),frYbins(s)) + fr.vel(s,3);
    
    gr.Xacc(frXbins(s),frYbins(s)) = gr.Xacc(frXbins(s),frYbins(s)) + fr.acc(s,1);
    gr.Yacc(frXbins(s),frYbins(s)) = gr.Yacc(frXbins(s),frYbins(s)) + fr.acc(s,2);
    gr.Aacc(frXbins(s),frYbins(s)) = gr.Aacc(frXbins(s),frYbins(s)) + fr.acc(s,3);
    
end

end