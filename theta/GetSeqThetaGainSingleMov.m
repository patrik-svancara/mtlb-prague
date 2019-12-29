function [gain] = GetSeqThetaGainSingleMov(seqtheta)

GAUSSOFFSET = 5;

% gain = square mean value across time and space
gain = mean(mean(mean(seqtheta.^2,4),3),2);
gain = reshape(gain,size(seqtheta,1),1);

end
