function [datapdf] = GetPdf2(data,edges,norm)
% calculates the PDF of given data set, returns symmetrical PDF
%
% input:   - data: n-column data vector
%          - edges = bin edges
%
% output:  - datapdf = 2n-column vector containing the PDFs


% default normalization
if (nargin == 2)
    
    norm = 'norm';
    
end

% memory preallocation
datapdf = zeros(length(edges)-1,2*size(data,2));

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

end
