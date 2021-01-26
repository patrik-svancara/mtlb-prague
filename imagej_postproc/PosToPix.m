function [pix] = PosToPix(pos,caminfo,scfactor)
% Reverts calculation of particle position and returns the position in
% pixel units, rounded to match indices of imread uint8 image.

% position back to microns
pix = pos*1e3;

% revert axis reversal and scaling factor
pix(:,1) = round(pix(:,1)./scfactor);

pix(:,2) = round(caminfo.resy - pix(:,2)./scfactor);

end