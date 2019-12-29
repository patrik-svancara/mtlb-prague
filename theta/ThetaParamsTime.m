% Simple script to check the the time averaging dependence

% for saving the data
GROUP = 'ring195K1100';
SAVE_FILE_TEMPLATE = '../../results/theta/params/%s/seqtheta_r%dm%dx%dt%d_%s.mat';

% time averaging vector (in frames)
frwinvect = [1 2 5 10:5:100];

% 38x32 mesh (in millimiters)
GRX = 38;
GRY = 32;
[GR.posx,GR.posy] =...
    meshgrid(linspace(0,movf(1).caminfo.resx*movf(1).scfactor/1e3,GRX),...
    linspace(0,movf(1).caminfo.resy*movf(1).scfactor/1e3,GRY));

% radius (in millimiters)
RAD = 10;

% for all the movies
for m = 1:length(movf)
    
     % message to the user
    fprintf('Processing movie %d/%d\n',m,length(movf));
    
    for f = 1:length(movf(m).fr)
        
        movf(m).fr(f).theta = ThetaFromFrame(movf(m).fr(f),GR,RAD);
            
    end
    
end
    
for w = 1:length(frwinvect)
        
    frwin = frwinvect(w);
    
    % messge to the user
    fprintf('Separation %d/%d\n',w,length(frwinvect));
    
    % init theta matrix
    seqtheta = zeros(length(movf),floor(movf(1).caminfo.nframes/frwin),GRY,GRX);
    
    for m = 1:length(movf)
        
        [seqtheta(m,:,:,:),~] = ThetaCombineFrames(movf(m),frwin);
        
    end
    
    % save the data
    save(sprintf(SAVE_FILE_TEMPLATE,GROUP,RAD,GRY,GRX,frwin,GROUP),'seqtheta');
    
end