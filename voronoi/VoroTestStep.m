% Simple script to see how the step between frames parameter affects the
% results.

TRYSTEPS = [32 16 12 8 4];

% struct init
vstatsitem = struct('rawpdf',[],'normpdf',[],'mom',[],'step',[],'pts',[],'alpha',[]);
vstats(1:length(TRYSTEPS)) = vstatsitem;

% Gaussian comparison plot
x = -4:0.2:4;
y = 1/sqrt(2*pi)*exp(-x.^2/2);

figure;
semilogy(x,y,'k--','LineWidth',1.3);
hold on;

cols = parula(length(TRYSTEPS));

for t = 1:length(TRYSTEPS)
    
    step = TRYSTEPS(t);
    
    % message to the user
    fprintf('*** Step %d ***\n',step);
    
    voro = VoroSingleGroup('groupH',step);
    
    vstats(t) = VoroStatsSingleGroup(voro);
    
    % plot for the user
    semilogy(vstats(t).normpdf(:,1),vstats(t).normpdf(:,2),'+-','LineWidth',1.3,'Color',cols(t,:));
    hold on;
    grid on;
    xlabel('Normalized Voronoi area');
    ylabel('PDF');
    title('Group H, all movies');
    
    pause(1);
    
end

legend(["Gauss"; "step " + num2str(TRYSTEPS')],'Location','south');