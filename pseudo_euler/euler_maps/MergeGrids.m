function [grtot] = MergeGrids(grtot,grpart)
% Merges partial data to the total grid; grids must be of the same size.

for i = 1:size(grtot,1)
    
    for j = 1:size(grtot,2)
        
        % merge only of there are data
        if (grtot(i,j).pts + grpart(i,j).pts ~= 0)
        
            grtot(i,j).vel = (grtot(i,j).vel.*grtot(i,j).pts + grpart(i,j).vel.*grpart(i,j).pts)...
                /(grtot(i,j).pts + grpart(i,j).pts);

            grtot(i,j).sqvel = (grtot(i,j).sqvel.*grtot(i,j).pts + grpart(i,j).sqvel.*grpart(i,j).pts)...
                /(grtot(i,j).pts + grpart(i,j).pts);

            grtot(i,j).pts = grtot(i,j).pts + grpart(i,j).pts;
            
        end
        
    end
end

end
        