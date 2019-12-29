function [cvs] = MakeCondVelStats(mov,lds,limits)
% Returns discriminated velocity statistics based on limits on line
% deviations in the vertical direction.
% limits is a (n,2) array that returns n cvs items.
% PDFs are not scaled in the horizontal direction.
% Assumes that tr structures contain tr.dif arrays.

% preallocate output structure
cvsitem = struct('pdf',[],'mom',[],'limit',[]);
cvs(1:size(limits,1)) = cvsitem;

% through all the conditions
for n = 1:size(limits,1)
    
    % message to the user
    fprintf('Processing limit %d/%d\n',n,size(limits,1));
    
    limit = limits(n,:);
    
    % make note about the (raw) limit
    cvs(n).limit = limit;
    
    % transform limit to mm (multiply by the vertical std)
    limit = limit.*lds.mom(4,2);
    
    % preallocate memory for collected velocities
    % there will be <= of velocity points than the number of diff points,
    % available from the stats
    allvel = zeros(lds.mom(1,1),2);
    
    % initialize allvel indes
    allvelind = 1;
    
    for m = 1:length(mov)
        
        for t = 1:length(mov(m).tr)
            
            if ~all(isnan(mov(m).tr(t).diff))
                
                % check if diff(:,2) lies within limit
                % WE CONSIDER ABDSOLUTE VALUES OF LINE DIFFS!
                limfilt = and(limit(1) < abs(mov(m).tr(t).diff(:,2)), abs(mov(m).tr(t).diff(:,2)) < limit(2));
                
                % add to allvel only if there are data to add
                if sum(limfilt) ~= 0
                    
                    % allvel indices where to put the data
                    thisvelind = allvelind + (0:sum(limfilt)-1);
                    
                    allvel(thisvelind,:) = mov(m).tr(t).vel(limfilt,:);
                    
                    % updare allvel index
                    allvelind = allvelind + sum(limfilt);
                    
                end
                
            end
            
        end
        
    end
    
    % trim empty points in the allvel array at the end
    allvel = allvel(1:allvelind-1,:);
        
    % velocity statistics
    cvs(n).mom = Moments(allvel);
    cvs(n).pdf = GetPdf(allvel,100,'norm');
    
end

end