function [jvel,vlength,jacc,alength] = Join(subtr,step)
% joins velocities and accelerations from subtracks back together

if (step == 1)
    
    jvel = subtr.vel;
    vlength = subtr.vlength;
    jacc = subtr.acc;
    alength = subtr.alength;
    
else

    % size
    vlength = sum([subtr(:).vlength]);
    alength = sum([subtr(:).alength]);

    % join the velocities
    if (vlength ~= 0)

        % memory preallocation
        jvel = zeros(vlength,3);

        for i = 1:vlength

            jvel(i,:) = subtr(mod(i-1,step)+1).vel(floor((i-1)/step)+1,:);
        end

    else

        jvel = [NaN NaN NaN];
    end

    % join the accelerations
    if (alength ~= 0)

        % memory preallocation
        jacc = zeros(alength,5);

        for i = 1:alength

            jacc(i,:) = subtr(mod(i-1,step)+1).acc(floor((i-1)/step)+1,:);    
        end

    else

        jacc = [NaN NaN NaN NaN NaN];

    end
    
end
end