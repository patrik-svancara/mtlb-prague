% Simple script to calculate and save T-sequences with sliding window

for g = 1:length(meta)
    
    fprintf('*** Run %d/%d: %s\n',g,length(meta),meta(g).group);
    
    fprintf('Loading data ...');
    
    load("../../results/tracks/movfr_"+meta(g).group+".mat");
    
    fprintf(' done.\nCalculating T...\n');
    
    for m = 1:length(movf)
        
        fprintf('%d/%d\n',m,length(movf));
        
        for f = 1:length(movf(m).fr)
            
            movf(m).fr(f).theta = ThetaFromFrame2(movf(m).fr(f),GR,1,5);
        
        end
        
    end
    
    fprintf('Creating T-sequences...');
    
    [slseqtheta,slseqpts] = ThetaCombineFramesSliding(movf,5);
    [slmseqtheta,slmseqpts] = ThetaCombineMovfSliding(movf,5);
    
    fprintf(' done.\nSaving data...');
    
    save("../../results/theta_res/sl"+meta(g).seqfile,'slseqtheta','slseqpts','-v7.3');
    save("../../results/theta_res/sl"+meta(g).mseqfile,'slmseqtheta','slmseqpts','-v7.3');
    
    fprintf(' done.\n');
    
end