function [datapdf] = GetPdf(data,nbins)
% Returns symmetrical PDF of n-column data

% default bin count
if (nargin == 1)
    nbins = 100;
end

% number of columns
ncols = size(data,2);

% memory preallocation
datapdf = zeros(nbins,2*ncols);

% look for the maximum value in the dataset
maxdata = max(max(abs(data)));

% generate the vector of bin edges (default: 101 edges)
edges = linspace(-maxdata,maxdata,nbins+1);

for j = 1:ncols

    % raw histogram
    [rawhist,~] = histcounts(data(:,j),edges);

    % conversion of bin edges to bin midpoints
    for i = 1:(length(edges)-1)

        datapdf(i,2*j-1) = (edges(i) + edges(i+1))/2;
        
    end

    % PDF normalization
    datapdf(:,2*j) = rawhist./(sum(rawhist)*(datapdf(2,2*j-1)-datapdf(1,2*j-1)));
    
end

end