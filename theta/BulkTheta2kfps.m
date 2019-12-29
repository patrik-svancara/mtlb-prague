% parametrization

load('../../results/metadata.mat');

frwin = 20;
rad_min = 1;
rad_max = 5;

load('../../results/mygrid.mat');

theta_save_template = '../../results/theta_res/%sseqtheta_%s.mat';
print_template = 'mseqtheta_%s_fr%03d.png';

% time for mseqtheta
time = (0:10:1490)/1e3;

load('../../results/mycolormap.mat');
    

for g = [17 22]
       
    fprintf('*** Group %s ***\n',meta(g).group);
    
    load(sprintf('../../results/tracks/movfr_%s.mat',meta(g).group));
    
    for m = 1:length(movf)
        
        fprintf('Theta for movie %d, frame %04d/%04d',m,0,length(movf(m).fr));
        
        for f = 1:length(movf(m).fr)
            
            fprintf('\b\b\b\b\b\b\b\b\b%04d/%04d',f,length(movf(m).fr));
            
            movf(m).fr(f).theta = ThetaFromFrame2(movf(m).fr(f),gr,rad_min,rad_max);
        
        end
        
        fprintf(' done.\n');
    end
    
    fprintf('Saving theta sequences...');
    
    [seqtheta,~] = ThetaCombineFrames(movf,frwin);
    [mseqtheta,~] = ThetaCombineMovf(movf,frwin);
    
    % divide by 2 as the sliding window is twice as wide
    [slseqtheta,~] = ThetaCombineFramesSliding(movf,frwin./2);
    [slmseqtheta,~] = ThetaCombineMovfSliding(movf,frwin./2);
    
    params = sprintf('r%dx%dm%dx%dt%d_%s',1,5,grx,gry,frwin,meta(g).group);
    
    save(sprintf(theta_save_template,'',params),'seqtheta');
    save(sprintf(theta_save_template,'m',params),'mseqtheta');
    
    save(sprintf(theta_save_template,'sl',params),'-v7.3','slseqtheta');
    save(sprintf(theta_save_template,'slm',params),'-v7.3','slmseqtheta');
    
    fprintf(' done.\n Printing mseqtheta frames, frame %03d/%03d',0,size(mseqtheta,1));
    %%%%
    
    outfolder = sprintf('../../results/theta_res/mseqtheta_vid/mseqtheta_%s',params);

    % make output folder, if it does not exist
    if exist(outfolder,'dir') == 0
        mkdir(outfolder) 
    end
    
    
     for t = 1:size(mseqtheta,1)

        fprintf('\b\b\b\b\b\b\b%03d/%03d',t,size(mseqtheta,1));

        imagesc(resx,resy,reshape(mseqtheta(t,:,:),gry,grx));

        axis xy;
        axis equal;

        pbaspect([grx gry 1]);

        colormap(mycols);
        caxis([-1 1]);
        h = colorbar;
        set(get(h,'title'),'string','T [s^{-1}]');

        xlabel('Horizontal dimension [mm]');
        ylabel('Vertical dimension [mm]');

        title(sprintf('%s, t = %.2f s',meta(g).group,time(t)),'Interpreter','none');

        print(gcf,'-dpng',sprintf('%s/%s',outfolder,sprintf(print_template,params,t)));
        
    end
    
    fprintf(' done.\n');
    
end