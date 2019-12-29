function [ ] = DataToMatFileSingleGroup_MultiParams(group,caminfo,scfactor,gaussparams)
% Returns standardized mov structures for further processing.
% (1) looks for all xls files in group folder
% (2) loads particle positions
% (3) Gaussian position and velocity filter in a loop to account for all parametrizations in gaussparams 2 x n vector
% (4) adds metadata to mov struct

% deps
addpath('../common');
addpath('../imagej_postproc');

INDATAFOLDER = '../../input_data/';
runs = dir([INDATAFOLDER group '/Results*.xls']);

RESTEMPLATE = '../../results/tracks/conv_%s/';
outfolder = sprintf(RESTEMPLATE,group);
if exist(outfolder,'dir') == 0
    
    mkdir(outfolder)
    
end

OUTFILETEMPLATE = [outfolder 'mov_%s_gauss%d.mat'];

% message to the user
disp('Initialization...');

% number of movies within a group
nmovies = length(runs);

% preallocate mov structure
movitem = struct('name',[],'gaussparams',[],'scfactor',[],'caminfo',[],'tr',[]);

for m = 1:nmovies
    
    mov(m) = movitem;
    mov(m).gaussparams = gaussparams(1,:);
    mov(m).scfactor = scfactor;
    mov(m).caminfo = caminfo;
    
end

% load raw positions movie by movie
for m = 1:length(mov)
    
    % message to the user
    fprintf('Loading movie %d/%d\n',m,length(mov));
    
    moviename = [runs(m).folder '/' runs(m).name];
    
    mov(m).name = moviename;
    
    mov(m).tr = DataFromIJfile(moviename,scfactor);
    
end

% save raw particle positions
rawmov = mov;

% for all gauss params
for g = 1:size(gaussparams(:,1))
    
    % message to the user
    fprintf('Applying filters %d/%d\n',g,size(gaussparams,1));
    
    % load raw particle positions
    mov = rawmov;
    
    % apply Gaussian smooting
    for m = 1:length(mov)
        
        % add actual gausparams
        mov(m).gaussparams = gaussparams(g,:);

        for t = 1:length(mov(m).tr)

            % reverse vertical axis so that + direction is to cryostat top
            mov(m).tr(t).pos(:,2) = scfactor*caminfo.resy - mov(m).tr(t).pos(:,2);

            % interpolate missing positions
            mov(m).tr(t).pos = Interpolate(mov(m).tr(t).pos);

            % raw positions, converted from microns to mm
            rawpos = mov(m).tr(t).pos/1e3;
            rawpos = mov(m).tr(t).pos;

            % use filter for positions, velocities and accelerations
            [mov(m).tr(t).pos,mov(m).tr(t).length] = PositionGauss(rawpos,gaussparams(g,:));
            [mov(m).tr(t).vel,mov(m).tr(t).vlength] = VelocityGauss(rawpos,1/mov(m).caminfo.fps,gaussparams(g,:));
            [mov(m).tr(t).acc,mov(m).tr(t).alength] = AccelerationGauss(rawpos,1/mov(m).caminfo.fps,gaussparams(g,:));

            % absolute values and acceleration projections
            mov(m).tr(t) = VelocityAbsolute(mov(m).tr(t));
            mov(m).tr(t) = AccelerationAbsolute(mov(m).tr(t));
            mov(m).tr(t) = AccelerationProjection(mov(m).tr(t));

            % trim tr(t).fr array to match filtered positions
            mov(m).tr(t).fr = mov(m).tr(t).fr(gaussparams(g,2)+1:end-gaussparams(g,2));

        end

    end

    % message to the user
    disp('Saving MATLAB file');

    % save the results
    save(sprintf(OUTFILETEMPLATE,group,g),'mov');
    
end

% message to the user
disp('Done.');

end
