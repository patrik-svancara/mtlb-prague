% bulk script for automatic processing of the data sets

% requires:
% allnfr - vector of number of frames
% allfps - vector of camera fps
% infold - input dir structure with folders
% caminfo, scfactor - preloaded structures

% processing details
gaussparams = [1.5 5];

rad_min = 1;
rad_max = 5;

frwin = 10;

% theta mesh grid
GRX = 115;
GRY = 101;

% save templates
theta_save_template = '../../results/tracks/movfrtheta_r%dx%dm%dx%d_%s.mat';
seqtheta_save_template = '../../results/theta_res/seqtheta_r%dx%dm%dx%dt%d_%s.mat';
mseqtheta_save_template = '../../results/theta_res/mseqtheta_r%dx%dm%dx%dt%d_%s.mat';
    

for i = 1:length(infold)
    
    % group name
    group = infold(i).name;
    
    % message to the user
    fprintf('*** *** PROCESSING GROUP %s *** ***\n',group);
    
    % update caminfo
    caminfo.fps = allfps(i);
    caminfo.nframes = allnfr(i);
    
    % 1. load data into mov structure
    mov = DataToMatFileSingleGroup(group,caminfo,scfactor,gaussparams);
    
    % 2. use mov to calculate movfr
    fprintf('*** Rearranging into frames ***\n');
    movf = GetFramesSingleGroup(group,mov);
    
    % 3. calculate theta & save the data
    fprintf('*** Calculating theta maps ***\n');
    
    % init theta mesh grid
    [GR.posx,GR.posy] =...
    meshgrid(linspace(0,movf(1).caminfo.resx*movf(1).scfactor/1e3,GRX),...
    linspace(0,movf(1).caminfo.resy*movf(1).scfactor/1e3,GRY));
    
    for m = 1:length(movf)
        
        fprintf('Processing movie %d/%d\n',m,length(movf));
        
        for f = 1:length(movf(m).fr)
            
            movf(m).fr(f).theta = ThetaFromFrame2(movf(m).fr(f),GR,rad_min,rad_max);
            
        end
        
    end
    
    %4. make & save theta sequences
    
    % movie-resolved theta slides
    [seqtheta,~] = ThetaCombineFrames(movf,frwin);
    save(sprintf(seqtheta_save_template,rad_min,rad_max,GRX,GRY,frwin,group),'seqtheta');
    
    % movie-averaged theta slides
    [mseqtheta,~] = ThetaCombineMovf(movf,frwin);
    save(sprintf(mseqtheta_save_template,rad_min,rad_max,GRX,GRY,frwin,group),'mseqtheta');
    
    
end