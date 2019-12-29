function [mdev] = GetMeanLinDev(pos,startind,endind)
% Returns st. deviation of the linear deviation for trajectory positions (as 1D vector).
% Boundaries (and line) is specified by startind and endind indices.

% interpolated linear positions
linpos = pos(startind) + (0:endind-startind)*((pos(endind) - pos(startind))/(endind -startind));

% vector of linear deviations
dev = pos(startind:endind) - linpos';

% standard deviation of the dev vector
mdev = std(dev);

end