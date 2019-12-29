function [allpwr] = ScaledPowerSingleMov(mov,step)
% Calculates scale-dependent vel / acc for each trajectory,
% and calculates the scale-dependent power

% GAUSSIAN CONVO PARAMS
GAUSSPARAMS = [1.5 5];

% deps
addpath('../power/');

% scaled time
sctau = step/mov.caminfo.fps;

% re-calculate scaled velocities and accelerations
for t = 1:length(mov.tr)
    
    [mov.tr(t).vel,mov.tr(t).vlength,mov.tr(t).acc,mov.tr(t).alength] ...
        = ScKinematicsSingleTr(mov.tr(t),step,sctau,GAUSSPARAMS);
    
    mov.tr(t).pwr = PowerSingleTr(mov.tr(t));
    
end

% run standard power data-gathering routine
allpwr = PowerSingleMov(mov);

end