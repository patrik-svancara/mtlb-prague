function [strveldata,crvveldata] = SplitStatsSingleGroup(mov)

strveldata = [ ];
crvveldata = [ ];

for m = 1:length(mov)
    
    [strvelmov,crvvelmov] = SplitVstatsSingleMov(mov(m));
    
    strveldata = cat(1,strveldata,strvelmov);
    crvveldata = cat(1,crvveldata,crvvelmov);
    
end

end