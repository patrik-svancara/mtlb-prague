% Simple script to check the the mesh density dependence
GROUP = 'ring195K1100';
SAVE_FILE_TEMPLATE = '../../results/theta/params/%s/seqtheta_r%dm%dx%dt%d_%s.mat';

% k*(38x32) mesh (in millimiters)
GRX = 38;
GRY = 32;

for k = 1:5
    [gr(k).posx,gr(k).posy] =...
        meshgrid(linspace(0,movf(1).caminfo.resx*movf(1).scfactor/1e3,k*GRX),...
        linspace(0,movf(1).caminfo.resy*movf(1).scfactor/1e3,k*GRY));
end

% radius (in millimeters)
RAD = 10;

% time averaging (in frames)
FRWIN = 20;

% calculate 4D theta sequences for each mesh size
for k = 1:length(gr)
    
    % message to the user
    fprintf('*** Mesh %d/%d ***\n',k,length(gr));
    
    % init theta matrix
    seqtheta = zeros(length(movf),floor(movf(1).caminfo.nframes/FRWIN),k*GRY,k*GRX);
    
    % for all the movies
    for m = 1:length(movf)
        
        % message to the user
        fprintf('Processing movie %d/%d\n',m,length(movf));
        
        for f = 1:length(movf(m).fr)
            
            movf(m).fr(f).theta = ThetaFromFrame(movf(m).fr(f),gr(k),RAD);
            
        end
        
        [seqtheta(m,:,:,:),~] = ThetaCombineFrames(movf(m),FRWIN);
        
    end
    
    % save the data
    save(sprintf(SAVE_FILE_TEMPLATE,GROUP,RAD,k*GRY,k*GRX,FRWIN,GROUP),'seqtheta');
    
end