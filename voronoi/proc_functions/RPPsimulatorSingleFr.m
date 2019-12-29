function [pos,pts] = RPPsimulatorSingleFr(fr,fov)
% Replaces measured particle positions with randomly placed particles
% within the FOV specified.

pos = rand(fr.pts,2).*[fov(1,2) fov(2,2)] + fov(:,1)';
pts = fr.pts;

end

