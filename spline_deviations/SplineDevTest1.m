function [spline] = SplineDevTest1(tsepvec,paramvec,numintpos)
% Returns spline structure of test results.
% (1) Single synthetic and monotonous track.

% dependencies
addpath('../common/');

% init of output structure
splitem = struct('pdf',[],'stats',[],'tsepvec',[],'params',[]);
spline(1:length(paramvec)) = splitem;

for p = 1:length(paramvec)
    
    trmean = paramvec(p,1);
    trstd = paramvec(p,2);
    
    spline(p).params = paramvec(p,:);
    
    % generate synthetic velocity of given std and mean
    % make always 1e4+1 trajectories
    if numintpos == 1
        
        tr.length = 1e4;
        
    else
        
        tr.length = 1e4/(numintpos+1);
        
    end
    
    tr.vel = randn(tr.length,1)*trstd + trmean;
    
    % integrate to obtain the positions
    tr.pos = zeros(tr.length,1);
    for ipos = 2:tr.length
        tr.pos(ipos) = trapz(tr.vel(ipos-1:ipos)) + tr.pos(ipos-1);
    end
    
    if numintpos > 1
        % interpolate positions between
        multf = numintpos + 1;
        
        tr.pos = interp1(1:multf:multf*tr.length,tr.pos,1:multf*(tr.length-numintpos));
        
        tr.length = length(tr.pos);
        
    end
            
    % memory prealloc
    spline(p).pdf = struct([]);
    
    % time separations
    spline(p).tsepvec = tsepvec;

    % through all the time steps
    for k = 1:length(tsepvec)
        
        tsep = tsepvec(k);
    
        % cutoff length
        lmax = tr.length - mod((tr.length - 1),tsep);

        % memory prealloc
        diff = zeros(lmax,1);

        % interpolate positions in both directions
        intpos = interp1(1:tsep:lmax,tr.pos(1:tsep:lmax),1:lmax,'spline');

        % differences
        for i = 1:lmax
            diff(i) = tr.pos(i) - intpos(i);
        end

        % replace zeros due to match with interpolation points by NaN
        diff(1:tsep:lmax) = NaN*diff(1:tsep:lmax);

        % remove these events
        diff = RemoveNaN(diff);
        
        % statistics and pdf of the diff vector
        spline(p).stats(k,:) = Moments(diff);
        
        % make and save PDF
        spline(p).pdf(k).pdf = GetPdf(diff,100,'norm');
        
    end
    
    % plot for the user    
    plot(spline(p).tsepvec,spline(p).stats(:,4)./spline(p).params(2),'.-');
    % plot(spline(p).tsepvec,spline(p).stats(:,4)./(spline(p).params(2)*spline(p).tsepvec'),'.-');
    % plot(spline(p).tsepvec,spline(p).stats(:,4),'.-');
    hold on;
    xlabel('Time separation [fr]');
    ylabel('Diff standard deviation [a.u.]');
    
    pause(1);
       
    
    
end

end