% Simple script to print the detected ring motion

% Change group and ringfile here
group = 'ring195K1100v2';
ringfile = 'ring_stdpar_trh0.15';
printfolder = sprintf('../../results/theta_res/ring/%2$s_%1$s',group,ringfile);
printfile = '%2$s_%1$s_fr%3$03d.png';

% make dedicated folder
if exist(printfolder,'dir') == 0
    mkdir(printfolder) 
end

% Load ring file
load(sprintf('../../results/theta_res/ring/%2$s_%1$s.mat',group,ringfile));

% resx = [0 24.9250];
% resy = [0 21.8640];
% GRX = 115;
% GRY = 101;

figure;

sind = 20;
eind = 150;
for t = sind:eind

    datatoplot = reshape(ring.p.data(t,:,:)+ring.n.data(t,:,:),GRY,GRX);
    i = imagesc(resx,resy,datatoplot);
    
    % do not plot zero values
    set(i,'AlphaData',~(datatoplot == 0));
    
    set(gca,'YDir','normal');
     
    % plot ring centers
    hold on;
    scatter(ring.p.posx(t),ring.p.posy(t),'ko','filled');
    scatter(ring.n.posx(t),ring.n.posy(t),'ko','filled');
    hold off;
    
    colormap(mycols);
    caxis([-1 1]*0.4);
    h = colorbar;
    set(get(h,'title'),'string','Theta [s^{-1}]');
    
    xlabel('Horizontal dimension [mm]');
    ylabel('Vertical dimension [mm]');
    
    title(sprintf('%s, t = %d ms',group,ring.time(t)));
    
    print(gcf,'-dpng',[printfolder '/' sprintf(printfile,group,ringfile,t)]);
    
    pause(0.5);
    
end