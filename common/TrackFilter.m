function [filt] = TrackFilter(tr)
% Checks trajectory against various filters and returns true if tr passed.

% trajectory length filter
if tr.length <= 5
    
    filt = false;
    return
    
end

% zero velocity filter = remove absolutely straight tracks
% 1e-10 to override rounding errors
if any(max(tr.vel,[],1) <= 1e-10)
    
    filt = false;
    return
    
end

% track passed
filt = true;

end