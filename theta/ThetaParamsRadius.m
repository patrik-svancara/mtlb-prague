% Simple script to check the the radius dependence

% for saving the data
GROUP = 'ring195K1100';
SAVE_FILE_TEMPLATE = '../../results/theta/params/%s/seqtheta_r%dm%dx%dt%d_%s.mat';

% list of radii (in millimiters)
radvect = [1:9 10:2:20];

% 38x32 mesh (in millimiters)
GRX = 38;
GRY = 32;
[GR.posx,GR.posy] =...
    meshgrid(linspace(0,movf(1).caminfo.resx*movf(1).scfactor/1e3,GRX),...
    linspace(0,movf(1).caminfo.resy*movf(1).scfactor/1e3,GRY));

% time averaging (in frames)
FRWIN = 40;

% calculate 4D theta sequences for each radius
for r = 1:length(radvect)
    
    rad = radvect(r);
    
    % message to the user
    fprintf('*** Radius %d/%d ***\n',r,length(radvect));
    
    % init theta matrix
    seqtheta = zeros(length(movf),floor(movf(1).caminfo.nframes/FRWIN),GRY,GRX);
    
    % for all the movies
    for m = 1:length(movf)
        
        % message to the user
        fprintf('Processing movie %d/%d\n',m,length(movf));
        
        for f = 1:length(movf(m).fr)
            
            movf(m).fr(f).theta = ThetaFromFrame(movf(m).fr(f),GR,rad);
            
        end
        
        [seqtheta(m,:,:,:),~] = ThetaCombineFrames(movf(m),FRWIN);
        
    end
    
    % save the data
    save(sprintf(SAVE_FILE_TEMPLATE,GROUP,rad,GRY,GRX,FRWIN,GROUP),'seqtheta');
    
end