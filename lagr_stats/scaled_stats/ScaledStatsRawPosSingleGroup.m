function [stats] = ScaledStatsRawPosSingleGroup(group,stepvec,caminfo)
% Provides scale-dependent vel / acc statistics for a series of steps
% defined by stepvec vector. Raw particle positions are obtained directly
% from ImageJ files and relevant differentiation operations are calculated
% afterwards.

GAUSS_PARAMS = [1.5 5];
SC_FACTOR = 27.3300;

% add deps
addpath('../');
addpath('../../common/');
addpath('../../imagej_postproc');

% prepare output folder
RESTEMPLATE = '../../../results/scaled_res/%s/';
outfolder = sprintf(RESTEMPLATE,group);
if exist(outfolder,'dir') == 0
    
    mkdir(outfolder)
    
end

% outfile template
OUTFIGTEMPLATE = [outfolder 'scstat_rawpos_%s_%s.png'];
OUTDATATEMPLATE = [outfolder 'scstat_rawpos_data_%s.mat'];

% location of input data
INDATAFOLDER = '../../../mosaic/';
runs = dir([INDATAFOLDER group '/Traj*.xls']);

% number of movies within a group
nmovies = length(runs);

% preallocate mov structure
movitem = struct('caminfo',[],'tr',[]);
mov(1:nmovies) = movitem;

% get raw trajectories
for m = 1:length(mov)
    
    % message to the user
    fprintf('\tProcessing movie %d/%d\n',m,length(mov));
    
    mov(m).caminfo = caminfo;
    
    moviename = [runs(m).folder '/' runs(m).name];
    
    mov(m).name = moviename;
    
    mov(m).tr = DataFromIJfile(moviename,SC_FACTOR);
        
    % trajectory initial manipulation
    for t = 1:length(mov(m).tr)
        
        % reverse vertical axis so that + direction is to cryostat top
        mov(m).tr(t).pos(:,2) = SC_FACTOR*caminfo.resy - mov(m).tr(t).pos(:,2);
        
        % interpolate missing positions
        mov(m).tr(t).pos = Interpolate(mov(m).tr(t).pos);
        
        % raw positions, converted from microns to mm
        mov(m).tr(t).pos = mov(m).tr(t).pos/1e3;
            
    end
    
end


% preallocation of stats struct (for each time step)  
statsitem = struct('velstats',[],'velpdf',[],'accstats',[],'accpdf',[],'step',[]);
stats(1:length(stepvec)) = statsitem;

% colors for the plot
cols = parula(length(stepvec));

for k = 1:length(stepvec)
    
    % current step
    step = stepvec(k);
    stats(k).step = step;
    
    % message to the user
    fprintf('\tProcessing step %d/%d\n',k,length(stepvec));
    
    % init global data vectors
    allvel = [ ];
    allacc = [ ];
    
    % for all the movies
    for m = 1:length(mov)
        
        [~,movvelpdf,movvel,~,~,movacc] = ScaledStatsSingleMov(mov(m),step,GAUSS_PARAMS);
        
        if ~isnan(movvel)
            
            allvel = cat(1,allvel,movvel);
            allacc = cat(1,allacc,movacc);
            
            % velocity pdf for the user
            
            semilogy(movvelpdf.raw(:,1),movvelpdf.raw(:,2),'-');
            hold on;
            semilogy(movvelpdf.raw(:,3),movvelpdf.raw(:,4),'-');
            hold off;
            xlabel('Particle velocity [mm/s]');
            ylabel('PDF');
            legend('Horizontal','Vertical','Location','northeast');
            title(sprintf('Step %d, run %d/%d',step,m,length(mov)),'Interpreter','none');

            pause(0.2);
            
        end
        
    end
    
    % global stats
    stats(k).velstats = Moments(allvel);
    stats(k).velpdf.raw = GetPdf(allvel);
    
    allvel = (allvel - stats(k).velstats.mean')./stats(k).velstats.std';
    stats(k).velpdf.norm = GetPdf(allvel);
    
    stats(k).accstats = Moments(allacc);
    stats(k).accpdf.raw = GetPdf(allacc);
    
    allacc = (allacc - stats(k).accstats.mean')./stats(k).accstats.std';
    stats(k).accpdf.norm = GetPdf(allacc);
    
    % plot for the user
    for tempk = 1:k
        legendline(tempk) = ...
            semilogy(stats(tempk).velpdf.raw(:,1),stats(tempk).velpdf.raw(:,2),...
            '-','Color',cols(tempk,:),'LineWidth',1.3);
        hold on;
        semilogy(stats(tempk).velpdf.raw(:,3),stats(tempk).velpdf.raw(:,4),...
            '--','Color',cols(tempk,:),'LineWidth',1.3);

    end
    xlabel('Particle velocity [mm/s]');
    ylabel('PDF');
    legend(legendline,string(stepvec(1:k)),'Location','northeast');
    title(sprintf('Step %d/%d',step,length(stepvec)),'Interpreter','none');
    
    hold off;

    pause(0.2);

end

% make & save final figures

% velocity distro
title(sprintf('Group %s',group),'Interpreter','none');
pause(2);

print(gcf,'-dpng',sprintf(OUTFIGTEMPLATE,'velpdf',group));

% acceleration distro
for k = 1:length(stepvec)
    legendline(k) = ...
        semilogy(stats(k).accpdf.raw(:,1),stats(k).accpdf.raw(:,2),...
        '-','Color',cols(k,:),'LineWidth',1.3);
    hold on;
    semilogy(stats(k).accpdf.raw(:,3),stats(k).accpdf.raw(:,4),...
        '--','Color',cols(k,:),'LineWidth',1.3);
end
xlabel('Particle acceleration [mm/s^2]');
ylabel('PDF');
legend(legendline,string(stepvec),'Location','northeast');
title(sprintf('Group %s',group),'Interpreter','none');
hold off;

pause(2);

print(gcf,'-dpng',sprintf(OUTFIGTEMPLATE,'accpdf',group));

% velocity flatness

for k = 1:length(stepvec)
    velflat(k,:) = stats(k).velstats.flat;
end

plot(stepvec,velflat(:,[1 2]),'o-','LineWidth',1.5);
xlabel('Scaling step [frames]');
ylabel('Velocity flatness');
legend('Horizontal','Vertical','Location','northeast');
title(sprintf('Group %s',group),'Interpreter','none');

pause(2);
print(gcf,'-dpng',sprintf(OUTFIGTEMPLATE,'velflat',group));

% save the data
save(sprintf(OUTDATATEMPLATE,group),'stats');

end