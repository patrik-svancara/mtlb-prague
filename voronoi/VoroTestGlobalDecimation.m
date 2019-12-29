% Test global (relative) decimation of points per frame

clear vstats;

GROUP = 'groupH';

STEP = 4;

% dilution coeeficients
ALPHAVECT = linspace(1,0.2,9);

% struct init
vstatsitem = struct('rawpdf',[],'normpdf',[],'mom',[],'step',[],'pts',[],'alpha',[]);
vstats(1:length(ALPHAVECT)) = vstatsitem;

% Gaussian comparison plot
x = -4:0.2:4;
y = 1/sqrt(2*pi)*exp(-x.^2/2);

figure;
semilogy(x,y,'k--','LineWidth',1.3);
hold on;

cols = parula(length(ALPHAVECT));

for a = 1:length(ALPHAVECT)
    
    alpha = ALPHAVECT(a);
    
    % message to the user
    fprintf('*** Dilution %g ***\n',alpha);
    
    voro = VoroSingleGroupAlpha(GROUP,STEP,alpha);
    
    vstats(a) = VoroStatsSingleGroup(voro);
    
    % plot for the user
    semilogy(vstats(a).normpdf(:,1),vstats(a).normpdf(:,2),'+-','LineWidth',1.3,'Color',cols(a,:));
    hold on;
    grid on;
    xlabel('Normalized Voronoi area');
    ylabel('PDF');
    legend(["Gauss"; [num2str(ALPHAVECT')]]);
    
    pause(1);
    
end