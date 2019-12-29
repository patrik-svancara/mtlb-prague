% Simple script to print the seqtheta sequence

% Change group and mseqtheta here + make sure the folders exist
% group = 'v20re10000';
load(grfile);

params = sprintf('r1x5m%dx%dt10',grx,gry);

outfolder = sprintf('../../results/theta_res/mseqtheta_vid/mseqtheta_%s_%s',params,group);

% make output folder, if it does not exist
if exist(outfolder,'dir') == 0
    mkdir(outfolder) 
end

printtemplate = 'mseqtheta_%s_%s_fr%03d.png';

% load data
load(sprintf('../../results/theta_res/mseqtheta_%1$s_%2$s.mat',params,group));

% resx = [0 24.9250];
% resy = [0 21.8640];
% GRX = 115;
% GRY = 101;

% figure;

fprintf('Processing frame %05d/%05d',0,size(mseqtheta,1));

for t = 1:size(mseqtheta,1)

    fprintf('\b\b\b\b\b\b\b\b\b\b\b%05d/%05d',t,size(mseqtheta,1));
    
    imagesc(resx,resy,reshape(mseqtheta(t,:,:),gry,grx));
    
    axis xy;
    axis equal;
    
    pbaspect([grx gry 1]);
    
    colormap(mycols);
    caxis([-1 1]*0.05);
    h = colorbar;
    set(get(h,'title'),'string','T [s^{-1}]');
    
    xlabel('Horizontal dimension [mm]');
    ylabel('Vertical dimension [mm]');
    
    title(sprintf('%s\nt = %.2f s',group,time(t)),'Interpreter','none');
    
    print(gcf,'-dpng',sprintf('%s/%s',outfolder,sprintf(printtemplate,params,group,t)));
    
    pause(0.5);
    
end

fprintf(' done.\n');
 
