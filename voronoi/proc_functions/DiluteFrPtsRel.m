function [fr] = DiluteFrPtsRel(fr,alpha)
% Returns diluted frame struct with dilution equal to alpha.
% Affects ONLY pos and pts fields, others are left unchanged.

% number of points to keep
ptskeep = floor(alpha*fr.pts);

% random coefficients
indkeep = randperm(fr.pts,ptskeep);

% return diluted values
fr.pos = fr.pos(indkeep,:);
fr.pts = length(indkeep);

end