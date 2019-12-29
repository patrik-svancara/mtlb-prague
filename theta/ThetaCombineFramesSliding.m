function [seqtheta,seqpts] = ThetaCombineFramesSliding(movf,frwin)
% Time averaging of T parameter, performed for each movie separately. Uses sliding time window.
% movf - input struct, with movf(m).fr(f).theta pre-calculated
% frwin - time averaging window, in frames !!! 2*frwin + 1 frames are used for merging !!!

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
seqtheta = zeros([length(movf) length(movf(1).fr) size(movf(1).fr(1).theta)]);
seqpts = zeros([length(movf) length(movf(1).fr)]);
    
for m = 1:length(movf)

    % obtain final seqtheta matrix
    for f = frwin+1:length(movf(1).fr) - frwin-1

        % summation indices, for each seqtheta slide
        indtosum = f-frwin:f+frwin;

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