function [mcorrall,wcorrall] = NormVelCorrelationSingleMov(mov,tsep,st)
% Velocity autocorrelation function for normalized velocities.

% dependencies
addpath('../common/');

% memory preallocation
mcorrs = zeros(length(mov.tr),size(mov.tr(1).vel,2));
wcorrs = zeros(length(mov.tr),1);

for i = 1:length(mov.tr)
    
%     disp(size(mov.tr(i).vel));
%     disp(size(st.velstats.mean));
%     disp(size(st.velstats.std));
    
    mov.tr(i).vel = (mov.tr(i).vel - st.velstats.mean')./st.velstats.std';
    
    [mcorrs(i,:),wcorrs(i)] = NormVelCorrelationSingleTr(mov.tr(i),tsep);
    
end

% remove empty cases
[mcorrs,ind] = RemoveNaN(mcorrs);
wcorrs = wcorrs(ind);

% calculate (weighted) mean value and corresponding weight
mcorrall = sum(mcorrs.*wcorrs,1)./sum(wcorrs);
wcorrall = sum(wcorrs);

end