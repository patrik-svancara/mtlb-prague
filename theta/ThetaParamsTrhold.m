% Simple script for studying the treshold for ring detection

% for saving the data
GROUP = 'jet133K100';
SAVE_TEMPLATE = '../../results/theta/params/%s/ring/ring_stdpar_trh%.2f_%s.mat';

% vector of tresholds
trhvect = [0.05 0.1:0.05:0.4 0.5 0.6];

for t = 1:length(trhvect)
    
    % message to the user
    fprintf('Procesing treshold %d/%d\n',t,length(trhvect));
    
    % treshold
    ring.trh = trhvect(t);
    
    % time
    ring.time = time;
    
    % positive and negative ring
    ring.p = FindRingPosition(GR,mstheta,ring.trh);
    ring.n = FindRingPosition(GR,mstheta,-ring.trh);
    
    % save the file
    save(sprintf(SAVE_TEMPLATE,GROUP,ring.trh,GROUP),'ring');
    
end