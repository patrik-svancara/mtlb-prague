function [pdfmap] = GetPdfMap(data,nbins)
% Returns 2D pdf map of strictly 2-column data

% default bin count
if (nargin == 1)
    nbins = [100 100];
end

pdfmap = struct('xedg',[],'yedg',[],'pdf',[],'xcen',[],'ycen',[]);

[pdfmap.pdf,pdfmap.xedg,pdfmap.yedg] = histcounts2(data(:,1),data(:,2),nbins,'Normalization','pdf');

% correct orientation of the FOV
pdfmap.pdf = pdfmap.pdf';

% conversion of bin edges to bin midpoints
for i = 1:(length(pdfmap.xedg)-1)

    pdfmap.xcen(i) = mean(pdfmap.xedg(i:i+1));

end

for i = 1:(length(pdfmap.yedg)-1)

    pdfmap.ycen(i) = mean(pdfmap.yedg(i:i+1));

end

end