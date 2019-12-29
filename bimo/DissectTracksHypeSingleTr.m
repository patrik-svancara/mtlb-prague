function [sg] = DissectTracksHypeSingleTr(tr,off)
% Dissection of a single trajectory after the classification has been done
% off = offset between acceleration and velocity vectors (second Gauss
% param)

% trajectory segment = [type start_ind end_ind physical_length]
sgstart = 1;
sglen = 1;
sgtype = tr.class(1);
sgind = 1;

% single-point tracks will not execute the following for cycle
if length(tr.class) == 1
    
    sg = [sgtype 1 1 1 0];
    return
    
end

% go row by row
for i = 2:length(tr.class)

    thistype = tr.class(i);

    % change of segment type = write segment and increase
    % counter
    if thistype == sgtype

        sglen = sglen + 1;

    else

        if sglen > 1
            % physical length of the segment, in mm
            sglenphys = norm(tr.pos(i-1+off,:) - tr.pos(sgstart+off,:));

        else
            % single point event has zero length
            sglenphys = 0;

        end

        % write segment information and increment counter
        sg(sgind,:) = [sgtype sgstart i-1 sglen sglenphys];
        sgind = sgind + 1;

        % init new segment search
        sgstart = i;
        sglen = 1;
        sgtype = thistype;

    end

end

% write last segment
if sglen > 1
    % physical length of the segment, in mm
    sglenphys = norm(tr.pos(i-1+off,:) - tr.pos(sgstart+off,:));

else
    % single point event has zero length
    sglenphys = 0;

end
sg(sgind,:) = [sgtype sgstart i sglen sglenphys];

end