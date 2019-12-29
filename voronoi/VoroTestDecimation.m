% Simple script to see the results change if we decimate the number
% of particle position per frames.

clear vstats;

load('../../data/tracks/groupH/movfr_groupH.mat');

origmovfr = movfr(1:10);

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
semilogy(x,y,'k--','LineWidth',2);
hold on;

cols = parula(length(ALPHAVECT));

for a = 1:length(ALPHAVECT)
    
    alpha = ALPHAVECT(a);
    
    % message to the user
    fprintf('*** Dilution %g ***\n',alpha);
    
    % restore all the points before each dilution
    movfr = origmovfr;
    
    voro = VoroSingleGroup(movfr(1:10),STEP,alpha);
    
    vstats(a) = VoroStatsSingleGroup(voro);
    
    % plot for the user
    semilogy(vstats(a).normpdf(:,1),vstats(a).normpdf(:,2),'.-','LineWidth',2,'Color',cols(a,:));
    hold on;
    grid on;
    xlabel('Normalized Voronoi area');
    ylabel('PDF');
    
    pause(1);
    
end