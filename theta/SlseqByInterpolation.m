function [slmseqtheta] = SlseqByInterpolation(mseqtheta,frwin)
% linear interpolation of mseqtheta in time

frames = size(mseqtheta,1);
grx = size(mseqtheta,2);
gry = size(mseqtheta,3);

% reshape mseqtheta
mseqtheta = reshape(mseqtheta,frames,grx*gry);

% sampling times
mseqtimes = (frwin/2)+((0:(frames-1))*frwin);

% desired times
sltimes = 1:frwin*frames;

% interpolate from samples
slmseqtheta = interp1(mseqtimes,mseqtheta,sltimes,'linear');

% reshape back to 3D matrix
slmseqtheta  = reshape(slmseqtheta,frames*frwin,grx,gry);

end