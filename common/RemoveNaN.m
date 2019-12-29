function [newdata,usedind] = RemoveNaN(data)
% Removes rows of NaN data from 2-dim data array.
% Returns cleaned array and list of used row indices.

% default return value
usedind = 1:size(data,1);

% find rows with NaN values
filt = any(isnan(data),2);

if any(filt)

    % keep only rows without NaN
    newdata = data(~filt,:);
    
    usedind = usedind(~filt);
    
else
    
    newdata = data;
    
end

end
