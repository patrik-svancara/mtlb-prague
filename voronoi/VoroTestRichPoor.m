% Comparison between poor frames (a few points) and decimated rich frames
% (a lot of points) to see whether the particles interact or not
% poor = 100..120 % pts decimated to 100 %
% rich = 200..inf % pts decimated to 100 %
% Returns vstats structure for a given 100 % level of points

%% obtain poor and rich structures

clear poor;
clear rich;

POORLIM = floor(1.2*FINALPTS);
RICHLIM = 2*FINALPTS;

STEP = 4;
NORMALIZE = false; % to obtain movie stats

FOV = 10.26/1000*[0 1280; 0 800];

item = struct('pos',[],'pts',[]);

for m = 1:length(movfr)

    poor(m).fr = item;
    poorind = 1;

    rich(m).fr = item;
    richind = 1;
    
    for f = 1:length(movfr(m).fr)
        
        thispts = movfr(m).fr(f).pts;
        
        % poor frames
        if and(thispts >= FINALPTS,thispts <= POORLIM)
            
            thisfr = DiluteFrPtsAbs(movfr(m).fr(f),FINALPTS);
            poor(m).fr(poorind).pos = thisfr.pos;
            poor(m).fr(poorind).pts = thisfr.pts;
            
            poorind = poorind + 1;
            
        % rich frames
        elseif thispts >= RICHLIM
            
            thisfr = DiluteFrPtsAbs(movfr(m).fr(f),FINALPTS);
            rich(m).fr(richind).pos = thisfr.pos;
            rich(m).fr(richind).pts = thisfr.pts;
            
            richind = richind + 1;
            
        end
        
    end
    
end

%% get Voronoi & preprocess Voronoi statistics

% memory prealloc 
voroitem = struct('areas',[],'pts',[],'mom',[],'step',[],'alpha',[]);
voropoor(1:length(poor)) = voroitem;
vororich(1:length(rich)) = voroitem;

for m = 1:length(poor)
    disp(m);
    
    for f = 1:length(poor(m).fr)
        
        [poor(m).fr(f).areas,poor(m).fr(f).areapts] = VoroSingleFr(poor(m).fr(f),FOV,1,false);
    
    end
    
    voropoor(m).step = STEP;
    voropoor(m).alpha = 1; % as we do not dilute particles in the precomputed data
    
    [voropoor(m).areas,voropoor(m).pts] = VoroSingleMov(poor(m),STEP,NORMALIZE);
    
    voropoor(m).mom = Moments(voropoor(m).areas);
    
    % normalize Voro areas
    voropoor(m).areas = voropoor(m).areas/voropoor(m).mom(2);
    
end

for m = 1:length(rich)
    disp(m);
    
    for f = 1:length(rich(m).fr)
        
        [rich(m).fr(f).areas,rich(m).fr(f).areapts] = VoroSingleFr(rich(m).fr(f),FOV,1,false);
    
    end
    
    vororich(m).step = STEP;
    vororich(m).alpha = 1; % as we do not dilute particles in the precomputed data
    
    [vororich(m).areas,vororich(m).pts] = VoroSingleMov(rich(m),STEP,NORMALIZE);
    
    vororich(m).mom = Moments(vororich(m).areas);
    
    % normalize Voro areas
    vororich(m).areas = vororich(m).areas/vororich(m).mom(2);
    
end

%% Obtain Voronoi statistics

poorst = VoroStatsSingleGroup(voropoor);
richst = VoroStatsSingleGroup(vororich);