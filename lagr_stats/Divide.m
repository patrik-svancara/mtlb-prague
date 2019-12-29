function [subtr] = Divide(pos,step)
% divides trajectory into 'step' parts with respect to the step;
% keeps only trajectories with length of at least 3 points
%
% output:   - subtr = array of traj structures
%           - short trajectories are marked with subtr(m).length = 0


% memory preallocation
subtr(step).length = [];
subtr(step).pos = [];

if (step == 1)
    
    subtr.pos = pos;
    subtr.length = size(pos,1);
    
else
    
    for m = 1:step

        % at least 2 positions
        if (1+floor((size(pos,1)-m)/step) >= 2)

            subtr(m).length = floor((size(pos,1)-m)/step)+1;
            subtr(m).pos = pos(m + step*((1:subtr(m).length)-1),:);

        else

            subtr(m).length = 0;
            subtr(m).pos = [NaN NaN];

        end

    end

end
end
