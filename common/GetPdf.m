function [datapdf] = GetPdf(data,nbins,norm)
% calculates the PDF of given data set, returns symmetrical PDF
%
% input:   - data: n-column data vector
%          - nbins = number of bins (optional, default: 100)
%
% output:  - datapdf = 2n-column vector containing the PDFs


% default bin count
if (nargin == 1)
    
    nbins = 100;
    norm = 'norm';
    
elseif (nargin == 2)
    
    norm = 'norm';
    
end

% at least two data points can be binned here
if size(data,1) > 1

    % memory preallocation
    datapdf = zeros(nbins,2*size(data,2));

    % look for the maximum value in the dataset
    maxdata = max(max(abs(data)));

    % generate the vector of bin edges (default: 101 edges)
    edges = linspace(-maxdata,maxdata,nbins+1);

    for j = 1:size(data,2)

        % raw histogram
        [rawhist,~] = histcounts(data(:,j),edges);

        % conversion of bin edges to bin midpoints
        for i = 1:(length(edges)-1)

            datapdf(i,2*j-1) = (edges(i) + edges(i+1))/2;
        end


        switch norm
            case 'norm'
                % PDF normalization
                datapdf(:,2*j) = rawhist./(sum(rawhist)*(datapdf(2,2*j-1)-datapdf(1,2*j-1)));    

            case 'raw'
                datapdf(:,2*j) = rawhist;
        end
        
    end
    
else
    datapdf = NaN*ones(nbins,2*size(data,2));
    
end

end