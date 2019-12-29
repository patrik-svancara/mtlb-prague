function [ ] = PrintThetaVortXYSlices(direct,rng,rng_vort,group,grfile,time)
% Caluclates RMS projections of theta / vorticity in the same plot. Results are printed as png frames.

FRWIN = 10;

% message to the user
fprintf('*** Group %s, slices in %s direction ***\nLoading data ...',group,direct);

% load grid data
load("../../ondrej/"+grfile);

% processing parameters
params = sprintf('r1x5m%dx%dt%d',grx,gry,FRWIN);
params_vort = sprintf('m%dx%dt%d',grx,gry,FRWIN);

% output folder
outfolder = sprintf('../../results/vort_res/thetavort_slices/thetavort_%sslices_%s_%s',direct,params,group);

% make output folder, if it does not exist
if exist(outfolder,'dir') == 0
    mkdir(outfolder); 
end

% output file template
OUTFILETEMPLATE = [outfolder '/' sprintf('thetavort_%sslices_%s_%s_fr%%05d.png',direct,params,group)];

% load data
load(sprintf('../../results/vort_res/seqvort_%s_%s.mat',params_vort,group),'seqvort');
load(sprintf('../../results/theta_res/mseqtheta_%s_%s.mat',params,group),'mseqtheta');

% set direction sensitive variables
switch direct
    case 'x'
        directnum = 2;
        pos = gr.posx(1,:);
        poslength = grx;
        res = resx;
        
    case 'y'
        directnum = 3;
        pos = gr.posy(:,1);
        poslength = gry;
        res = resy;
end

% find adequate plot ranges (MAGIC)
% rng = [0 max(max(rms(mseqtheta,directnum)))];
% rng_vort = [0 max(max(rms(seqvort,directnum)))]; 

% plot and print slices
fprintf(' done.\nProcessing frame %05d/%05d',0,size(seqvort,1));

for x = 1:size(seqvort,1)

    % progress
    fprintf('\b\b\b\b\b\b\b\b\b\b\b%05d/%05d',x,size(seqvort,1));
    
    yyaxis left;
    plot(pos,reshape(rms(seqvort(x,:,:),directnum),[1 poslength]),'-','LineWidth',1.5);
    ylim([0 rng_vort]);
    ylabel('RMS vorticity [s^{-1}]');

    yyaxis right;
    plot(pos,reshape(rms(mseqtheta(x,:,:),directnum),[1 poslength]),'-','LineWidth',1.5);
    ylim([0 rng]);
    ylabel('RMS T [s^{-1}]');
    
    xlim(res);
    
    switch direct
        case 'x'
            xlabel('Horizontal position [mm]');
    
        case 'y'
            xlabel('Vertical position [mm]');
            
    end

    title(sprintf('Group %s, t = %.2f s',group,time(x)),'Interpreter','none');
    
    % pause(0.5);

    print(gcf,'-dpng',sprintf(OUTFILETEMPLATE,x));

end

fprintf(' done.\n');

end 