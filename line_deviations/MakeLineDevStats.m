function [lds] = MakeLineDevStats(mov)
% Returns statistics of line deviations for a list of movies.
% PDFs are scaled by the standard deviation and centered to the mean.
% Assumes that tr structures contain tr.dif arrays.

% deps
addpath('../common/');

% preallocate memory
alldifflength = 0;

for m = 1:length(mov)
    
    for t = 1:length(mov(m).tr)
        
        alldifflength = alldifflength + mov(m).tr(t).truedifflength;
        
    end
    
end
alldiff = zeros(alldifflength,2);

% initialize alldiff index
alldiffind = 1;

% through all the movies
for m = 1:length(mov)
    
    % message to the user
    fprintf('Processing run %d/%d\n',m,length(mov));
    
    % through all the tracks
    for t = 1:length(mov(m).tr)
        
        if ~all(isnan(mov(m).tr(t).diff))
            
            % indices where to put the diff into alldiff array
            thisdiffind = alldiffind + (0:mov(m).tr(t).truedifflength-1);
            
            alldiff(thisdiffind,:) = RemoveNaN(mov(m).tr(t).diff);
            
           % increment all diff index
           alldiffind = alldiffind + mov(m).tr(t).truedifflength;
           
        end
        
    end
    
end

% init structure
lds = struct;

% get statistics
lds.mom = Moments(alldiff);

% get normalized PDFs
lds.pdf = GetPdf((alldiff - lds.mom(2,:))./lds.mom(4,:),100,'norm');

end