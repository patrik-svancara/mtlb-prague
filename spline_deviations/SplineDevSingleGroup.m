function [spline] = SplineDevSingleGroup(group,tsepvec)
% Returns spline interpolated position deviations for given time steps.

% dependencies
addpath('../common/');

% prepare output folder
RESTEMPLATE = '../../data/spline_dev_res/%s/';
outfolder = sprintf(RESTEMPLATE,group);
if exist(outfolder,'dir') == 0
    
    mkdir(outfolder);
    
end

% outfile template
OUTFIGTEMPLATE = [outfolder 'spline_%s_%s.eps'];
OUTDATATEMPLATE = [outfolder 'spline_data_%s.mat'];

% load data
MOVFRTEMPLATE = '../../data/tracks/%s/mov_%s.mat';
load(sprintf(MOVFRTEMPLATE,group,group));

% obtain camera fps
fps = mov(1).caminfo.fps;

% init of output structure
splitem = struct('pdf',[],'stats',[],'tsep',[]);
spline(1:length(tsepvec)) = splitem;

% through all the time steps
for k = 1:length(tsepvec)
    
    tsep = tsepvec(k);
    
    % time separation in ms
    spline(k).tsep = tsep/fps*1000;
    
    % memory prealloc
    diff = [ ];
    
    % through all the movies
    for m = 1:length(mov)
                
        % get differences in microns
        partdiff = SplineDevSingleMov(mov(m),tsep)*1000;
        
        % partdiff can be empty for large time lags
        if ~isempty(partdiff)
        
            % merge old and new data
            diff = cat(1,diff,partdiff);
        
            % obtain partial PDF
            partpdf = GetPdf(partdiff,100,'norm');
        
            %partial plot for the user
            semilogy(partpdf(:,1),partpdf(:,2),'.-');
            hold on;
            semilogy(partpdf(:,3),partpdf(:,4),'.-');
            hold off;
            xlabel('Position deviation [microns]');
            ylabel('PDF');
            legend('Horizontal','Vertical');
            title(sprintf('Step %d, run %d/%d',tsep,m,length(mov)));

            pause(0.2);
            
        end
        
    end
    
    % group-wide distribution statistics
    spline(k).stats = Moments(diff);
    
    % group-wide PDF
    spline(k).pdf = GetPdf(diff,100,'norm');

    % plot for the user, normalized by tsep, area kept unitary
    stdev = zeros(k,2);
    for j = 1:k
        stdev(j,:) = spline(j).stats(4,:)./spline(j).tsep;
    end

    plot([spline(1:k).tsep],stdev,'o-');
    xlabel('Time lag between points [ms]');
    ylabel('Normalized standard deviation [mm/s]');
    legend('Horizontal','Vertical');
    title(group);
    
    pause(1);
    
end

% save final std plot
print(gcf,'-depsc',sprintf(OUTFIGTEMPLATE,'std',group));

% save final PDF plot
for j = 1:length(tsepvec)
        semilogy(spline(j).pdf(:,1)/spline(j).tsep,spline(j).pdf(:,2)*spline(j).tsep,'r-');
        hold on;
        semilogy(spline(j).pdf(:,3)/spline(j).tsep,spline(j).pdf(:,4)*spline(j).tsep,'b-');
end
hold off;
xlabel('Normalized horizontal position deviation [mm/s]');
ylabel('PDF');
title(group);
pause(1);

print(gcf,'-depsc',sprintf(OUTFIGTEMPLATE,'pdf',group));

% save the data
save(sprintf(OUTDATATEMPLATE,group),'spline');

end