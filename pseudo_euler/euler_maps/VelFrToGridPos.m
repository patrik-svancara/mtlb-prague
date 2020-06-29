function [gr] = VelFrToGridPos(gr,pos,vel)
% Adds velocity from a single frame/track to the position-based grid structure

[frcts,~,~,frXbins,frYbins] = histcounts2(pos(:,1),pos(:,2),gr.Xedges,gr.Yedges);

% add point count
gr.pts = gr.pts + frcts;

% filter points that are within bins
filt = and(frXbins ~= 0,frYbins ~=0);
idx = 1:length(frXbins);

% add data to bins
for s = idx(filt)

    gr.Xvel(frXbins(s),frYbins(s)) = gr.Xvel(frXbins(s),frYbins(s)) + vel(s,1);
    gr.Xvel2(frXbins(s),frYbins(s)) = gr.Xvel2(frXbins(s),frYbins(s)) + vel(s,1).^2;
    
    gr.Yvel(frXbins(s),frYbins(s)) = gr.Yvel(frXbins(s),frYbins(s)) + vel(s,2);
    gr.Yvel2(frXbins(s),frYbins(s)) = gr.Yvel2(frXbins(s),frYbins(s)) + vel(s,2).^2;

    gr.Avel(frXbins(s),frYbins(s)) = gr.Avel(frXbins(s),frYbins(s)) + vel(s,3);
    gr.Avel2(frXbins(s),frYbins(s)) = gr.Avel2(frXbins(s),frYbins(s)) + vel(s,3).^2;
    
end

end