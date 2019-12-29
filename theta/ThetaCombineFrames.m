function [seqtheta,seqpts] = ThetaCombineFrames(movf,frwin)
% Time averaging of pseudovorticity data for a single movie.
% Data are merged inside the time window specified by frwin.
% movf - input struct, with movf(m).fr(f).theta pre-calculated
% frwin - time averaging window, in frames

% memory prealloc
frametheta = zeros([length(movf) length(movf(1).fr) size(movf(1).fr(1).theta)]);
framepts = zeros([length(movf) length(movf(1).fr)]);

% obtain weighted theta data across frames
for m = 1:length(movf)
    
    for f = 1:length(movf(m).fr)

        frametheta(m,f,:,:) = movf(m).fr(f).theta*movf(m).fr(f).pts;
        framepts(m,f) = movf(m).fr(f).pts;

    end
    
end

% memory prealloc
seqtheta = zeros([length(movf) floor(length(movf(1).fr)/frwin) size(movf(1).fr(1).theta)]);
seqpts = zeros([length(movf) floor(length(movf(1).fr)/frwin)]);
    
for m = 1:length(movf)

    % obtain final seqtheta matrix
    for f = 1:floor(length(movf(m).fr)/frwin)

        % summation indices, for each seqtheta slide
        indtosum = (f-1)*frwin+(1:frwin);

        % points per slide
        seqpts(m,f) = sum(framepts(m,indtosum));

        % if there are no points in the slide, set all values = 0
        % otherwise add theta data
        if seqpts(m,f) > 0

            seqtheta(m,f,:,:) = sum(frametheta(m,indtosum,:,:),2)/seqpts(m,f);

        end
        
    end
    
end

end