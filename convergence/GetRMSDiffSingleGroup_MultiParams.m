% MultiParameter processing of convergence data

% BASIC VARIABLES
ALENGTH = 9;
BLENGTH = 14;
NPAIRS = ALENGTH * (BLENGTH -1);

GROUP = '10t1hz';
%%

% init struct
rmsconvind = struct('velrms',[],'accrms',[],'a',[],'b',[],'movind',[]);
rmsconv(1:NPAIRS) = rmsconvind;

ind = 1;

% fill in processing parameters
for aind = 1:ALENGTH
    
    for bind = 1:(BLENGTH -1)
        
        rmsconv(ind).a = gaussparams(BLENGTH*(aind-1)+1,2);
        rmsconv(ind).b = gaussparams(BLENGTH*(aind-1)+(bind:bind+1),3);
        rmsconv(ind).movind = gaussparams(BLENGTH*(aind-1)+(bind:bind+1),1);
        
        ind = ind+1;
    
    end
    
end

% process movies pair by pair
for ind = 1:length(rmsconv)
    
    % message to the user
    fprintf('Processing pair %d/%d\n',ind,length(rmsconv));
    
    % single-pair results
    [velrms,accrms] = GetRMSDiffSingleGroup(GROUP,rmsconv(ind).movind(1),rmsconv(ind).movind(2));
    
    disp(velrms);
    
    rmsconv(ind).velrms = velrms;
    rmsconv(ind).accrms = accrms;
    
end
    
