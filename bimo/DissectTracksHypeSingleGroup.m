function [mov] = DissectTracksHypeSingleGroup(mov,slowp,fastp,off)
% Dissect trajectories according the hyperbolic separation scheme
% off = offset between acceleration and velocity vectors (second Gauss
% param)

for m = 1:length(mov)
    
    for t = 1:length(mov(m).tr)
        
        if mov(m).tr(t).alength > 0
        
            % classification (transpose in the end to make sure that these
            % are 1-column vectors)
            mov(m).tr(t).class = HypeClassTool(mov(m).tr(t).vel(1+off:end-off,2),...
                mov(m).tr(t).acc(:,2),slowp,fastp)';
            
            % dissection
            mov(m).tr(t).sg = DissectTracksHypeSingleTr(mov(m).tr(t),off);
            
            % fixing fake transitions shorter than 2 frames
            [mov(m).tr(t).sg,mov(m).tr(t).class] = FixShortTransitions(mov(m).tr(t),2,off);
            
        end
        
    end
    
end

end
        