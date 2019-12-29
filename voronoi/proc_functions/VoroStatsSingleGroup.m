function[vorostats] = VoroStatsSingleGroup(voro,bins,manfilt)
% Joins voro data and provides final statistical data.
% Voro items can be manually sorted out by bolean manfilt filter.

% apply manfilt
if nargin == 3
    
    voro = voro(manfilt);
    
end
    
% handle the use of # of bins (bins is scalar) or edges (bins is a vector)
if length(bins) == 1
    
    bintype = 'nbins';
    
else
    
    bintype = 'edges';
    
end
    

% memory prealloc
vorostats = struct('rawpdf',[],'normpdf',[],'mom',[],'step',[],'pts',[],'alpha',[]);

for v = 1:length(voro)
    
    vorostats.pts(v) = sum([voro(v).pts]);
    
end

allareas = zeros(sum(vorostats.pts),1);
allind = 1;

% join all valid data

for v = 1:length(voro)
    
    thisind = allind + (0:sum(voro(v).pts)-1);
    
    % add partial data
    allareas(thisind) = voro(v).areas;
    
    % update global index
    allind = allind + sum(voro(v).pts);
    
end

% fill the vorostats structure
vorostats.step = voro(1).step;
vorostats.alpha = voro(1).alpha;
vorostats.mom = Moments(allareas);

vorostats.rawpdf = GetPdf(allareas,100,'norm');

% normalization according to Monchaux
logareas = log(allareas);
normareas = (logareas - mean(logareas))/std(logareas);

% choose nbins or edges pdf function
switch bintype
    
    case 'nbins'
        vorostats.normpdf = GetPdf(normareas,bins,'norm');
        
    case 'edges'
        vorostats.normpdf = GetPdf2(normareas,bins,'norm');
        
end

end