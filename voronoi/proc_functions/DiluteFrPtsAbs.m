function [fr] = DiluteFrPtsAbs(fr,wantpts)
% Returns diluted frame struct with wantpts points left.
% Affects ONLY pos and pts fields, others are left unchanged.

% handle input
if wantpts == fr.pts
    % no dilution needed, do nothing
    return
    
elseif wantpts > fr.pts
    % not enough points, do nothing
    warning('Not enough points for this dilution.');
    return
    
end

% random point indices to keep
indkeep = randperm(fr.pts,wantpts);

% return diluted values
fr.pos = fr.pos(indkeep,:);
fr.pts = length(indkeep);

end