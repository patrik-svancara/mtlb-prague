function [seqtheta,seqpts] = ThetaCombineMovfSliding(movf,frwin,movfind)
% Calculates the movie-specific seqthetas and merges them across the movies. Uses sliding time window.
% movf - input struct with movf(m).fr(f).theta pre-calculated
% frwin - time averaging window, in frames
% [optional] movfind - only movies specified by movfind indices will be merged

% handle optional param
if (nargin == 2)
    movfind = 1:length(movf);
end

% obtain seqtheta for the desired movies
for m = 1:length(movfind)
    
    [seqtheta(m,:,:,:),seqpts(m,:)] = ThetaCombineFramesSliding(movf(movfind(m)),frwin);
    
    % weigh the data with seqpts
    seqtheta(m,:,:,:) = seqtheta(m,:,:,:).*seqpts(m,:);
    
end

% all points per slide
seqpts = sum(seqpts,1);
seqpts = reshape(seqpts,1,numel(seqpts));

% renormalize seqpts to be 1 if there are no data and n if there are n points
seqpts = seqpts + double(seqpts == 0);

% normalize the weighted data (keep 0 for frames without data)
seqtheta = sum(seqtheta,1)./seqpts;

% reshape the result
seqsize = size(seqtheta);
seqtheta = reshape(seqtheta,seqsize(2:end));

end