function [mov] = DataToMatFileSingleGroup(group,caminfo,scfactor,gaussparams)
% Returns standardized mov structure for further processing.
% (1) looks for all csv files in group folder
% (2) loads particle positions
% (3) Gaussian position and velocity filter
% (4) adds metadata to mov struct

INDATAFOLDER = '../../mosaic/';
runs = dir([INDATAFOLDER group '/Traj*.csv']);

OUTFILETEMPLATE = '../../results/tracks/mov_%s.mat';


% number of movies within a group
nmovies = length(runs);

if nmovies == 0
    
    fprintf('No movies detected in %s. Exiting.\n',[INDATAFOLDER group '/']);
    mov = struct;
    return
end

fprintf('Initializing with %d movies detected.\n',nmovies);

% preallocate mov structure
movitem = struct('name',[],'gaussparams',[],'scfactor',[],'caminfo',[],'tr',[]);

for m = 1:nmovies
    
    mov(m) = movitem;
    mov(m).gaussparams = gaussparams;
    mov(m).scfactor = scfactor;
    mov(m).caminfo = caminfo;
    
end

% load raw positions movie by movie
for m = 1:nmovies
    
    % message to the user
    fprintf('Loading movie %d/%d\n',m,length(mov));
    
    moviename = [runs(m).folder '/' runs(m).name];
    
    mov(m).name = moviename;
    
    mov(m).tr = DataFromIJfile(moviename,scfactor);
    
end

% apply Gaussian smooting
for m = 1:nmovies
    
    % message to the user
    fprintf('Applying filters for movie %d/%d\n',m,length(mov));
    
    for t = 1:length(mov(m).tr)
        
        % reverse vertical axis so that + direction is to cryostat top
        mov(m).tr(t).pos(:,2) = scfactor*caminfo.resy - mov(m).tr(t).pos(:,2);
        
        % interpolate missing positions
        [mov(m).tr(t).pos,mov(m).tr(t).fr,mov(m).tr(t).intflg] = Interpolate(mov(m).tr(t).pos,mov(m).tr(t).fr);
        
        % raw positions, converted from microns to mm
        rawpos = mov(m).tr(t).pos/1e3;
        
        % use filter for positions
        [mov(m).tr(t).pos,mov(m).tr(t).length] = PositionGauss(rawpos,gaussparams);
        
        % keep unprocessed positions
        % mov(m).tr(t).pos = rawpos;
        % mov(m).tr(t).length = size(mov(m).tr(t).pos,1);
        
        % use filter for velocities and accelerations
        [mov(m).tr(t).vel,mov(m).tr(t).vlength] = VelocityGauss(rawpos,1/mov(m).caminfo.fps,gaussparams);
        [mov(m).tr(t).acc,mov(m).tr(t).alength] = AccelerationGauss(rawpos,1/mov(m).caminfo.fps,gaussparams);
        
        % absolute values and acceleration projections
        mov(m).tr(t) = VelocityAbsolute(mov(m).tr(t));
        mov(m).tr(t) = AccelerationAbsolute(mov(m).tr(t));
        % mov(m).tr(t) = AccelerationProjection(mov(m).tr(t));
        
        % trim tr(t).fr array to match filtered positions
        mov(m).tr(t).fr = mov(m).tr(t).fr(gaussparams(2)+1:end-gaussparams(2));
        
        % trim tr(t).intflg array to match filtered positions
        mov(m).tr(t).intflg = mov(m).tr(t).intflg(gaussparams(2)+1:end-gaussparams(2));
        
    end
    
end

% remove trajectories that yield zero length after filter
mov = RemoveEmptyTr(mov);

% message to the user
disp('Saving MATLAB file...');

% save the results
save(sprintf(OUTFILETEMPLATE,group),'mov');

% message to the user
disp('Done.');

end
