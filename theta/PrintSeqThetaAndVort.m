function [ ] = PrintSeqThetaAndVort(group,grfile,time)
% Simple function to print the seqtheta sequence alongside with vorticity

% RANGES
TRANGE = 0.1;
VRANGE = 8;

% load colors
load('../../results/mycolormap.mat');

% load the grid
load(grfile);

vortparams = sprintf('m%dx%dt10',grx,gry);
thetaparams = ['vf1r1x5' vortparams];


outfolder = sprintf('../../results/vort_res/thetavort_vid/thetavort_%s_%s',thetaparams,group);

% make output folder, if it does not exist
if exist(outfolder,'dir') == 0
    mkdir(outfolder) 
end

printtemplate = 'thetavort_%s_%s_fr%05d.png';

% load mseqtheta
load(sprintf('../../results/theta_res/mseqtheta_%1$s_%2$s.mat',thetaparams,group));

% load vortcitiy
load(sprintf('../../results/vort_res/seqvort_%1$s_%2$s.mat',vortparams,group));

% figure;

fprintf('*** Processing group %s ***\nFrame %05d/%05d',group,0,size(mseqtheta,1));

for t = 1:1:size(mseqtheta,1)
    
    % progress bar
    fprintf('\b\b\b\b\b\b\b\b\b\b\b%05d/%05d',t,size(mseqtheta,1));
    
    subplot(1,2,1);
    
    imagesc(resx,resy,reshape(mseqtheta(t,:,:),gry,grx));
    
    axis xy;
    axis equal;
    
    pbaspect([grx gry 1]);
    
    colormap(mycols);
    caxis([-1 1]*TRANGE);
    colorbar;
    
    xlabel('Horizontal dimension [mm]');
    ylabel('Vertical dimension [mm]');
    
    title('T [s^{-1}]');
    
    subplot(1,2,2);
    
    imagesc(resx,resy,-reshape(seqvort(t,:,:),gry,grx));
    
    axis xy;
    axis equal;
    
    pbaspect([grx gry 1]);
    
    colormap(mycols);
    caxis([-1 1]*VRANGE);
    colorbar;
    
    xlabel('Horizontal dimension [mm]');
    ylabel('Vertical dimension [mm]');
    
    title('-\omega [s^{-1}]');
    
    % overall title
    sgtitle(sprintf('Group %s, t = %.2f s',group,time(t)),'Interpreter','none');
    
    print(gcf,'-dpng',sprintf('%s/%s',outfolder,sprintf(printtemplate,thetaparams,group,t)));
    
    % pause(0.5);
    
    % clear figure
    clf;
    
end

fprintf(' -- done.\n');

end