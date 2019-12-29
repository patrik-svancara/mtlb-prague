function [velstats,velpdf,veldata,accstats,accpdf,accdata] = ScaledStatsSingleMov(mov,step,gaussparams)
% Calculates scale-dependent vel / acc for each trajectory.
% Uses standard functions for vel / acc statistics.

% deps
addpath('../velstats/');
addpath('../accstats/');

% scaled time
sctau = step/mov.caminfo.fps;

% re-calculate scaled velocities and accelerations
for t = 1:length(mov.tr)
    
    [mov.tr(t).vel,mov.tr(t).vlength,mov.tr(t).acc,mov.tr(t).alength] ...
        = ScKinematicsSingleTr(mov.tr(t),step,sctau,gaussparams);
    
end

% run stats routines
[velstats,velpdf,veldata] = VelStatsSingleMov(mov);
[accstats,accpdf,accdata] = AccStatsSingleMov(mov);

end