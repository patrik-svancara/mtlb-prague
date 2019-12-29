function [diff,truedifflength] = LineDevSingleTrack(tr,tsep)
% Returns vector of trajectory deviations from linear interpolations.
% diff is of the same length as the track, non-defined diffs are marked as
% NaNs. If the track is not long enough, diff returns single Nan value.

% minimum length filter
if tr.length <= 2*tsep
    
    diff = NaN;
    truedifflength = 0;
    return
    
end

% preallocate memory
diff = NaN*ones(tr.length,2);

% pre-caclculate point-wise linear interpolations
intpos = (tr.pos(2*tsep+1:end,:) + tr.pos(1:end-2*tsep,:))/2;

% position differences, adequately located in diff
diff(tsep+1:end-tsep,:) = tr.pos(tsep+1:end-tsep,:) - intpos;

% true diff length, to preallocate stats
truedifflength = tr.length - 2*tsep;

end
