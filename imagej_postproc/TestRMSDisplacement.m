function [rms] = TestRMSDisplacement(group)

INDATAFOLDER = '../../mosaic/';
runs = dir([INDATAFOLDER group '/Traj*.xls']);

% number of movies within a group
nmovies = length(runs);

if nmovies == 0
    
    fprintf('No movies detected in %s. Exiting.\n',[INDATAFOLDER group '/']);
    rms = [NaN NaN];
    return
end

% load raw positions movie by movie and calculate RMS displacement
for m = 1:nmovies
    
    % message to the user
    fprintf('Loading movie %d/%d\n',m,nmovies);
    
    moviename = [runs(m).folder '/' runs(m).name];
    
    mov(m).name = moviename;
    
    mov(m).tr = DataFromIJfile(moviename,1);
    
    pts = 0;
    rmssum = [0 0];
    
    for t = 1:length(mov(m).tr)
        
        if mov(m).tr(t).length >= 2
            
            mov(m).tr(t).disp = mov(m).tr(t).pos(2:end,:) - mov(m).tr(t).pos(1:end-1,:);
            
            pts = pts + size(mov(m).tr(t).disp,1);
            rmssum = rmssum + sum(mov(m).tr(t).disp.^2,1);
            
        end
        
    end
    
    rms(m,:) = sqrt(rmssum / pts);
    
end
