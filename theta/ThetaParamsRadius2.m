% Simple script to check the the radius dependence

% for saving the data
GROUP = 'ring195K1100';
SAVE_FILE_TEMPLATE = '../../results/theta/params/%s/seqtheta2_r%dx%dm%dx%dt%d_%s.mat';

% list of radii (in millimiters)
radvect = [2:9 10:2:20];

% minimal radius constant
RAD_MIN = 1;

% 115x101 square mesh (in millimiters)
GRX = 115;
GRY = 101;
[GR.posx,GR.posy] =...
    meshgrid(linspace(0,movf(1).caminfo.resx*movf(1).scfactor/1e3,GRX),...
    linspace(0,movf(1).caminfo.resy*movf(1).scfactor/1e3,GRY));

% time averaging (in frames)
FRWIN = 10;

% calculate 4D theta sequences for each radius
for r = 1:length(radvect)
    
    rad = radvect(r);
    
    % message to the user
    fprintf('*** Radius %d/%d ***\n',r,length(radvect));
    
    % calc theta for all the movies
    for m = 1:length(movf)
        
        % message to the user
        fprintf('Processing movie %d/%d\n',m,length(movf));
        
        for f = 1:length(movf(m).fr)
            
            movf(m).fr(f).theta = ThetaFromFrame2(movf(m).fr(f),GR,RAD_MIN,rad);
            
        end
        
    end
    
    % time + movie averaging
    [seqtheta,~] = ThetaCombineMovf(movf,FRWIN);
    
    % save the data
    save(sprintf(SAVE_FILE_TEMPLATE,GROUP,RAD_MIN,rad,GRY,GRX,FRWIN,GROUP),'seqtheta');
    
end